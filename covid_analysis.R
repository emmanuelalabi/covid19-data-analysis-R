library(httr)
library(rvest)

get_wiki_covid19_page <- function() {

  wiki_base_url <- "https://en.wikipedia.org/w/index.php?title=Template:COVID-19_testing_by_country"
}
get_wiki_covid19_page()
url <-"https://en.wikipedia.org/w/index.php?title=Template:COVID-19_testing_by_country"
page <- read_html(url)
tables_node <- html_nodes(page, "table")
second_table <- tables_node[[2]]
df <- as.data.frame(html_table(second_table, fill = TRUE))
head(df)
preprocess_covid_data_frame <- function(data_frame) {
  shape <- dim(data_frame)
  data_frame<-data_frame[!(data_frame$`Country.or.region`=="World"),]
  data_frame <- data_frame[1:172, ]
  data_frame["Ref."] <- NULL
  data_frame["Units.b."] <- NULL
  names(data_frame) <- c("country", "date", "tested", "confirmed", "confirmed.tested.ratio", "tested.population.ratio", "confirmed.population.ratio")
  data_frame$country <- as.factor(data_frame$country)
  data_frame$date <- as.factor(data_frame$date)
  data_frame$tested <- as.numeric(gsub(",","",data_frame$tested))
  data_frame$confirmed <- as.numeric(gsub(",","",data_frame$confirmed))
  data_frame$'confirmed.tested.ratio' <- as.numeric(gsub(",","",data_frame$`confirmed.tested.ratio`))
  data_frame$'tested.population.ratio' <- as.numeric(gsub(",","",data_frame$`tested.population.ratio`))
  data_frame$'confirmed.population.ratio' <- as.numeric(gsub(",","",data_frame$`confirmed.population.ratio`))

  return(data_frame)
}

clean_df <-preprocess_covid_data_frame(df)
head(clean_df)

wd <- getwd()
file_path <- paste(wd, sep="", "/covid.csv")
print(file_path)
file.exists(file_path)
covid_csv_file <- download.file("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMDeveloperSkillsNetwork-RP0101EN-Coursera/v2/dataset/covid.csv", destfile="covid.csv")
covid_data_frame_csv <- read.csv("covid.csv", header=TRUE, sep=",")
covid_data_frame_csv <- read.csv("/resources/RP0101EN/v2/M5_Final/covid.csv", stringsAsFactors = FALSE)
head(covid_data_frame_csv)
subset_df <-covid_data_frame_csv[5:10,c("country","confirmed")]
subset_df
subset_df <-covid_data_frame_csv[118:120,c("country","confirmed","date")]
subset_df
total_confirmed <- sum(covid_data_frame_csv$confirmed, na.rm = TRUE)
total_tested <- sum(covid_data_frame_csv$tested,na.rm = TRUE)
positive_ratio <- total_confirmed/total_tested
total_confirmed
total_tested
positive_ratio
positive_ratio
countries <- covid_data_frame_csv$country
countries
class(countries)
covid_data_frame_csv$country <- as.character(covid_data_frame_csv$country)
countries_AtoZ <- sort(covid_data_frame_csv$country)
countries_AtoZ
countries_ZtoA <- sort(covid_data_frame_csv$country, decreasing = TRUE)
country_col <- "country"
countries <- covid_data_frame_csv[[country_col]]
united_countries <- grep("^United",countries, value = TRUE)
#grep is used to find names starting with particular words or word
united_countries
nig_countries <- grep("^Nig",countries, value = TRUE)
nig_countries
nria_countries <- grep("ria^",countries, value = TRUE)
nria_countries

#pick two countries of interest

countries_of_interest <- c("Nigeria","Ghana")
country_col <- "country"
two_countries_data <-  subset(covid_data_frame_csv,covid_data_frame_csv[[country_col]]%in% countries_of_interest)
two_countries_data[, c(country_col,"tested","confirmed")]

countries_of_interest <- c("Nigeria","Ghana")
country_col <- "country"
two_countries_data <- subset(covid_data_frame_csv,covid_data_frame_csv[[country_col]] %in% countries_of_interest )
two_countries_data$confirmed_ratio <- two_countries_data$confirmed/ two_countries_data$tested.population.ratio
two_countries_data[, c(country_col, "confirmed","tested.population.ratio","confirmed_ratio")]


#compare which one is larger
larger_ratio_countryv <- two_countries_data[which.max(two_countries_data$confirmed_ratio), country_col]
cat("The country with the larger confirmed-to-population ratio is:", larger_ratio_countryv, "\n")
two_countries_data$confirmed.population.ratio <- two_countries_data$confirmed /two_countries_data$tested.population.ratio

nigeria_ratio <- two_countries_data$confirmed.population.ratio[two_countries_data$country == "Nigeria"]
ghana_ratio <- two_countries_data$confirmed.population.ratio[two_countries_data$country == "Ghana"]

if (nigeria_ratio > ghana_ratio){
  print ("Nigeria has a higher confirmed -to- populatio ratio,showing  higher infection risk.")
}else if(ghana_ratio > nigeria_ratio){
  print("Ghana has a higher confirmed -to- populatio ratio,showing  higher infection risk.")
}else{
  print("Both Nigeria and Ghane have same confirmed-to-population.")
}

#let me make threshold (5% = 0.05)

threshold <- 0.05
covid_data_frame_csv$confirmed.population.ratio <- covid_data_frame_csv$confirmed / covid_data_frame_csv$tested.population.ratio
low_risk_countries <- subset(covid_data_frame_csv, confirmed.population.ratio < threshold)
print(low_risk_countries[, c("country","confirmed","tested.population.ratio","confirmed.population.ratio")])

#let me make threshold (1% = 0.01)

threshold <- 0.01
covid_data_frame_csv$confirmed.population.ratio <- covid_data_frame_csv$confirmed / covid_data_frame_csv$tested.population.ratio
low_risk_countries <- subset(covid_data_frame_csv, confirmed.population.ratio < threshold)
print(low_risk_countries[, c("country","confirmed","tested.population.ratio","confirmed.population.ratio")])

