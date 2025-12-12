library(tidyverse)
library(lubridate)
library(MASS)
#...............................................................................
#                                                                              .
#  Process Precip Data                                                         .
#                                                                              .
#...............................................................................
precip <- read_csv(
  "raw_data/sju_ncei_data.csv",
  na = c("", "NA"),         # treat empty strings as NA
  col_types = cols(Date = col_character(),
    `TAVG (Degrees Fahrenheit)` = col_double(),
    `TMAX (Degrees Fahrenheit)` = col_double(),
    `TMIN (Degrees Fahrenheit)` = col_double(),
    `PRCP (Inches)` = col_double(),
    `SNOW (Inches)` = col_double(),
    `SNWD (Inches)` = col_double())) %>%
  
  mutate(Date = mdy(Date),
         year = year(Date),
         # convert from inches to mm
         prcp_mm = `PRCP (Inches)` * 25.4) %>%
  # remove na's
  filter(!is.na(prcp_mm))
    

rainy_days <- precip %>% filter(prcp_mm > 0) #keep only days where it rained

threshold <- quantile(rainy_days$prcp_mm, 0.95, na.rm = TRUE) # define extreme precipitation (mm)
threshold

# Define extreme events by the calculated threshold
extreme_events <- precip %>%
  mutate(is_extreme = prcp_mm >= threshold) %>%
  group_by(year) %>%
  summarise(extreme_count = sum(is_extreme, na.rm = TRUE),
            total_rain_days = sum(prcp_mm > 0, na.rm = TRUE))

# View the distribution of daily precip at SJU
ggplot(rainy_days, aes(x = prcp_mm)) +
  geom_histogram(binwidth = 5, fill = "skyblue") +
  geom_vline(xintercept = threshold, color = "red", lwd = 1.2) +
  labs(title = "Distribution of Daily Rainfall in San Juan",
       subtitle = paste("95th percentile threshold =", round(threshold, 2),
                        "mm"),
       x = "Daily precipitation (mm)",
       y = "Frequency")

# Rename columns 
extreme_events <- extreme_events %>%
  rename(extreme_events = extreme_count,
         rainy_days = total_rain_days)


#...............................................................................
#                                                                              .
#  Process SST Data                                                            .
#                                                                              .
#...............................................................................



#...............................................................................
#                                                                              .
#  Process NAO Data                                                            .
#                                                                              .
#...............................................................................

nao <- read_csv("raw_data/NAO_INDEX.csv", show_col_types = FALSE)

yearly_nao <- nao %>% 
  group_by(YEAR) %>% 
  summarize(avg_index = mean(INDEX)) %>% 
  janitor::clean_names() %>% 
  rename(avg_nao_index = avg_index)

#...............................................................................
#                                                                              .
#  Process ENSO Data                                                            .
#                                                                              .
#...............................................................................

enso <- read_csv("raw_data/MONTHLY_ENSO_INDEX.csv", show_col_types = FALSE) %>% 
  janitor::clean_names()

yearly_enso <- enso %>% 
  group_by(yr) %>% 
  summarize(avg_anom = mean(anom),
            avg_total_c = mean(total_c),
            avg_lim_adjust = mean(lim_adjust)) %>% 
  rename(year = yr,
         avg_enso_anom = avg_anom)

#...............................................................................
#                                                                              .
#  Merge datasets                                                              .
#                                                                              .
#...............................................................................


extr_weather <- left_join(extreme_events, yearly_enso, by = "year")
extr_weather
extr_weather_left <- left_join(extr_weather, yearly_nao, by = "year")

#...............................................................................
#                                                                              .
#  Create the model                                                            .
#                                                                              .
#...............................................................................

model_nb <- glm.nb(extreme_events ~ year + avg_enso_anom + avg_nao_index,
                   data = extr_weather_left)

summary(model_nb)

# Create prediction grid for the two focal variables
pred_nao <- expand_grid(
  avg_nao_index = seq(min(extr_weather_left$avg_nao_index),
                      max(extr_weather_left$avg_nao_index),
                      length.out = 100)
) %>%
  mutate(
    year = mean(extr_weather_left$year, na.rm = TRUE),
    avg_enso_anom = mean(extr_weather_left$avg_enso_anom, na.rm = TRUE)
  )

pred_nao_se <- predict(
  model_nb, 
  newdata = pred_nao,
  type = "link",
  se.fit = TRUE
)


# Convert link scale predictions to response scale
pred_nao_nb <- pred_nao %>%
  mutate(
    # linear predictor (log-scale)
    log_pred = pred_nao_se$fit,
    
    # 95% CI on the link (log) scale using qnorm
    log_lwr = qnorm(0.025, mean = log_pred, sd = pred_nao_se$se.fit),
    log_upr = qnorm(0.975, mean = log_pred, sd = pred_nao_se$se.fit),
    
    # convert to response scale
    pred = exp(log_pred),
    pred_lwr = exp(log_lwr),
    pred_upr = exp(log_upr)
  )



# pred_nao_se$fit <- exp(pred$fit)
# pred_nao$lwr <- exp(pred$fit - 1.96 * pred$se.fit)
# pred_year$upr <- exp(pred$fit + 1.96 * pred$se.fit)

#...............................................................................
#                                                                              .
#  Visualization                                                               .
#                                                                              .
#...............................................................................

# Plot 1: Yearly Counts of 
ggplot(extreme_events, aes(x=year, y=extreme_events)) +
  geom_line(alpha=0.6) +
  labs(x = "Year", y = "Extreme Precipitation Events") +
  theme_classic()

# Plot 0 Daily Rainfall
ggplot(precip, aes(x=Date, y=`PRCP (Inches)`)) +
  geom_line(alpha=0.6) +
  labs(x = "Year", y = "Daily Rainfall") +
  theme_classic()

#Plot 2
ggplot() +
  geom_point(data = extr_weather_left,
             aes(x = avg_nao_index, y = extreme_events),
             alpha = 0.4, color = "grey40") +
  
  geom_ribbon(data = pred_nao_nb,
              aes(x = avg_nao_index, ymin = pred_lwr, ymax = pred_upr),
              fill = "grey80", alpha = 0.5) +
  
  geom_line(data = pred_nao_nb,
            aes(x = avg_nao_index, y = pred),
            color = "steelblue", linewidth = 1.2) +
  
  labs(
    x = "NAO Index",
    y = "Predicted Extreme Precip Events",
    title = "Effect of NAO on Extreme Precipitation (NB Model)"
  ) +
  theme_classic()


# Plot 3

pred_sst <- data.frame(
  sst = seq(min(extreme_events$sst),
            max(extreme_events$sst), length.out=100),
  year = mean(extreme_events$year),
  enso = mean(extreme_events$enso),
  nao = mean(extreme_events$nao)
)

pred_sst_pred <- predict(model_nb, pred_sst, type="link", se.fit=TRUE)
pred_sst$fit <- exp(pred_sst_pred$fit)
pred_sst$lwr <- exp(pred_sst_pred$fit - 1.96 * pred_sst_pred$se.fit)
pred_sst$upr <- exp(pred_sst_pred$fit + 1.96 * pred_sst_pred$se.fit)

ggplot(pred_sst, aes(x=sst, y=fit)) +
  geom_line(color="steelblue") +
  geom_ribbon(aes(ymin=lwr, ymax=upr), alpha=0.2) +
  theme_minimal() +
  labs(x="SST anomaly", y="Predicted extreme events")

