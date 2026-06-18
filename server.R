#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {
  # loading the data
  data1 <- read.csv("data/preliminary-data-of-national-population-and-housing-census-2021-english2.csv")
  
  # providing the option to select district according to the province selected by the user
  output$district <- renderUI({
    data3 <- data1 %>% filter(Province == input$province)
    selectInput("district", "District", choices = c("Select District" = "overall_dis", data3$District))
  })
  
  # providing the option to select local level according to the district selected by the user
  output$localLevel <- renderUI({
    data3 <- data1 %>% filter(Province == input$province)
    data4 <- filter(data3, District == input$district)
    selectInput("local", "Local Level", choices = c("Select Local Level" = "overall_local", data4$Local.Level.Name))
  })
  #functionalizing the download button
  # output$downloadData<- downloadHandler(
  #     filename =  function(){
  #             #paste(highlight(input$province,input$district,input$local),"pdf",sep=".")
  #       "plots.pdf"
  #     },
  #     content = function(file) {
  #       # Create the combined PDF file
  #       rmarkdown::render(
  #         input = "report.Rmd",
  #         output_format = "pdf_document",
  #         output_file = file,
  #         envir = new.env(parent = globalenv())
  #       )
  #     })
    
  #)
  # output$downloadData = downloadHandler(
  #   filename = function() {"plots.pdf"},
  #   content = function(file) {
  #     pdf(file, onefile = TRUE)
  #     grid.arrange(ns(vals$plotSSC))
  #     dev.off()
  #   }
  # )
  
  
  # reducing the data into flexible format into user input
  deduced_data <- reactive({
    deduce(input$province, input$district, input$local, data1)
  })
 
  
  # Displaying Highlights as text
  output$highlights <- renderUI(
    {
      text <- highlight(input$province,input$district,input$local)
      tags$div(
        style = "background-color: #e8f0fe; padding: 2px; border-radius: 1px;",
        tags$span(tags$strong(text))
      )
    }
    
  )
  output$total <- renderText({
    #data2 <- deduce(input$province,input$district, input$local,data1)
    data2 <- deduced_data()
    sum(data2$total.population)
  })
  
  output$male <- renderText(
    {
      #data2 <- deduce(input$province,input$district, input$local,data1) 
      data2 <- deduced_data()
      sum(data2$total.male)
            
    }
  )
  output$female <- renderText((
    {
      #data2 <- deduce(input$province,input$district, input$local,data1) 
      data2 <- deduced_data()
      sum(data2$total.female)
      
    }
  ))
  
  
  
  
  # plotting the overall population of the nation shown when the app first loads
  output$overall <- renderPlot({
    #ploting the bar chart using the user defined function chart()
    data2 <- deduced_data()
    chart(input$province,input$district,input$local,data2)
  })
  
  # plotting the overall household numbers by each province
  output$house <- renderPlot({
    #barplot(data2$total.household, names.arg = data2$Province, main = "No of household by Province", col = rainbow(length(data2)))
    data2 <- deduced_data()
    chart_house(input$province,input$district,input$local,data2)
  }
  )
  
  # Pie chart on the population census tab
  output$cake <- renderPlot({
    # Counting total male and female population for pie chart
    data2 <- deduced_data()
    malefemale <- c(sum(data2$total.male), sum(data2$total.female))
    names(malefemale) <- c("Male", "Female")
    pie(malefemale,col = rainbow(2),main = "Population by gender")
  }
  )
  
  # Showing preliminary census data in a table
  output$table <- renderTable(
    {
      data2 <- deduced_data()
      data2
    }
  )
  
  
  # Trend Tab
  output$trend_pop <- renderPlot(
    {
      #data1 <- read.csv("inter-censal-population-changes-from-1911-to-2011-ad.csv")
      intercensal("population")+ 
        scale_y_continuous(labels = scales::comma)
      # ggplot(data1, aes(Census.year,Population,group = Group))+
      #   geom_line(size = 1,stat = "identity")+
      #   ggtitle("Population Trend")+
      #   geom_point(col = "blue")+
      #   scale_y_continuous(labels = scales::comma)
    }
  )
  output$growth <- renderPlot(
    {
      intercensal("growth")
      # data1 <- read.csv("inter-censal-population-changes-from-1911-to-2011-ad.csv")
      # ggplot(data1, aes(Census.year,Inter.censal.changes,group = Group))+
      #   geom_line(size = 1,stat = "identity")+
      #   ggtitle("Intercensal Changes in Population")+
      #   geom_point(col = "blue")
      #  # scale_y_continuous(labels = scales::comma)
    }
  )
  
  
  
  
  # Educational Status Tab
  
 

   output$literacy_status <- renderPlot({
    literacy_status(input$province1)
   })
   
   
   # District Selection for literacy Rates
   # output$district1 <- renderUI({
   #  district_Input(input$province1)
   # })
   # Plot for literacy rates
   output$literacy_rates <- renderPlot(
     {
       literacy_rates(input$province1)
     }
   )
   # Displaying Data tables in the data tapPanel
   output$literacy_status_t <- renderTable(
     {
       table_literacy_status(input$province1)
     }
   )
   
   output$literacy_rates_t <- renderTable(
     {
       table_literacy_rates(input$province1)
     }
   )
  
  
  # Miscellaneous Tab
  output$others <- renderPlot(
    {
      chart_others(input$visual)
    }
  )
  output$others_t <- renderTable(
    {
      table_others(input$visual)
    }
  )
  
  
  
})




# Abstracting using function

# this function decduces the data into flexible format according to user input
deduce <- function(province,district,local,data1){
  if(province == "overall"){
    data2 <- data1 %>% group_by(Province)%>% summarise(
      total.family = sum(Total.family.number),
      total.household = sum(Total.household.number),
      total.population = sum(Total.population),
      total.male = sum(Total.Male),
      total.female = sum(Total.Female)
    )
    
  }else if(district == "overall_dis"){
    data2 <- data1 %>% filter(Province == province)
    data2 <- data2 %>% group_by(District) %>% summarise(
      total.family = sum(Total.family.number),
      total.household = sum(Total.household.number),
      total.population = sum(Total.population),
      total.male = sum(Total.Male),
      total.female = sum(Total.Female)
    )
  }else if(local == "overall_local"){
    data3 <- data1 %>% filter(District == district)
    data2 <- data3 %>% group_by(Local.Level.Name) %>% summarise(
      total.family = sum(Total.family.number),
      total.household = sum(Total.household.number),
      total.population = sum(Total.population),
      total.male = sum(Total.Male),
      total.female = sum(Total.Female)
    )
  }else{
    data3 <- data1 %>% filter(Local.Level.Name == local)
    data2 <- data3 %>% group_by(Local.Level.Name) %>% summarise(
      total.family = sum(Total.family.number),
      total.household = sum(Total.household.number),
      total.population = sum(Total.population),
      total.male = sum(Total.Male),
      total.female = sum(Total.Female)
    
    )
  }
  return(data2)
  
}


# this  function plots the data according to user input
chart <- function(province, district, local, data2) {
  # Using user-defined function deduce to reduce the data into a flexible format for plotting
  
  
  if (province == "overall") {
    labels <- data2$Province
    xlab <- "Province"
    title <- "Population by Province"
  } else if (district == "overall_dis") {
    labels <- data2$District
    xlab <- "District"
    title <- "Population by District"
  } else if (local == "overall_local") {
    labels <- data2$Local.Level.Name
    xlab <- "Local Level"
    title <- "Population by Local Level"
  } else {
    
    return(NULL)  # Return NULL to exit the function if none of the conditions match
  }
  Labels <- reorder(labels,data2$total.household)
  ggplot(data2, aes(x = reorder(labels,total.population), y = total.population, fill = Labels)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 0, size = 10)) +
    xlab(xlab) +
    ylab("Population") +
    ggtitle(title) +
    scale_y_continuous(labels = scales::comma)+
    theme(plot.title = element_text(size = 50,colour = "#FF8800",family = "Times New Roman"))
}



# Ploting for no. of household

chart_house <- function(province, district, local, data2) {
  #data2 <- deduce(province, district, local, data1)
  
  
  if (province == "overall") {
    labels <- data2$Province
    xlab <- "Province"
    title <- "No. of Households by Province"
  } else if (district == "overall_dis") {
    labels <- data2$District
    xlab <- "District"
    title <- "No of Households by District"
  } else if (local == "overall_local") {
    labels <- data2$Local.Level.Name
    xlab <- "Local Level"
    title <- "No of Households by Local Level"
  } else {
    hist(local)
    return(NULL)  # Return NULL to exit the function if none of the conditions match
  }
  Labels <- reorder(labels,data2$total.household)
  ggplot(data2, aes(x = reorder(labels,total.household), y = total.household, fill = Labels)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 0, size = 10)) +
    xlab(xlab) +
    ylab("Household") +
    ggtitle(title) +
    scale_y_continuous(labels = scales::comma)+
    theme(plot.title = element_text(size = 42,colour = "#FF8800",family = "Times New Roman"))

    
}




# Intercensal line graph function


intercensal <- function(repre){
  data1 <- read.csv("data/inter-censal-population-changes-from-1911-to-2011-ad.csv")
  if(repre == "population"){
    height <- data1$Population 
    ylab <- "Population"
    title <- "Population Trend"
  }else if(repre == "growth"){
    height <- data1$Inter.censal.changes
    ylab <- "Change in Population"
    title <- "Intercensal Population Growth"
  }else{
    print("meaning less parameter passed into function")
    return(NULL)
  }
  linePlt <- ggplot(data1, aes(Census.year,height,group = Group))+
                 geom_line(linewidth = 1,stat = "identity")+
                 ggtitle(title)+
                 ylab(ylab)+
                 geom_point(col = "blue")+
                 theme(plot.title = element_text(size = 40,colour = "#FF8800",family = "Times New Roman"))
                #scale_y_continuous(labels = scales::comma)
  return(linePlt)
}


#function for displaying highlight header message

highlight <- function(province,district,local){
  if(province == "overall"){
    result <- "Nepal"
  }else if(district == "overall_dis"){
    result <- province
  }else if(local == "overall_local"){
    result <- district
  }else{
    result <- local
  }
  result2 <- paste("Population Highlights of ",result)
  
  return(result2)
}



# Function for plotting the charts on miscellaneous tab
chart_others <- function(visual) {
  if (visual == "maritial") {
    # Specify the encoding as "UTF-8" to handle special characters
    data1 <- read.csv("data/Marital_status.csv", encoding = "UTF-8")
    data1 <- data1 %>% rename("category" = "X.U.FEFF.category")
    title <- "Nationwise Maritial Status "
  } else {
    return(NULL)
  }
  Label <- reorder(data1$category,data1$Total)
  ggplot(data1, aes(reorder(category,Total), Total, fill = category)) +
    geom_bar(stat = "identity")+
    xlab("status")+
    ggtitle(title)+
    ylab("Percentage")
}


# Function for building table of miscelaneous tab

table_others <- function(visual){
  if(visual == "maritial"){
    data1 <- read.csv("data/Marital_status.csv", encoding = "UTF-8")
    data1 <- data1 %>% rename("category" = "X.U.FEFF.category")
  }else if(visual == "employment"){
    data1 <- read.csv("Province_wise_employment_status.csv")
  }else{
    return(NULL)
  }
  data1
}
  
# Function for Taking District Input in education Tab

# district_Input <- function(province){
#   data1 <- read.csv("literacy-rates.csv")
#   data1 <- data1 %>% filter(Province == province)
#   selectInput("district1", "District", choices = c("Select District" = "overall_dis", data1$District))
#     
#   
# }

#function for plotting literacy rates

literacy_rates<- function(province){
 

  if(province == "overall"){
    data1 <- read.csv("data/Province_wise_literacy_rates.csv")
    data1 <- rename(data1, "Province" = "ï..Province")
    Labels <- reorder( data1$Province,data1$Total)
    xlab <- "Province"
    title <- "Literacy rate by Province"

  }else {
    data1 <- read.csv("data/literacy-rates.csv")
    data1 <- data1 %>% filter(Province == province)
    Labels <- reorder( data1$District,data1$Total)
    xlab <- "District"
    title <- "Literacy rate by District"
  }
 
  ggplot(data1, aes(x = reorder(Labels,Total), y = Total, fill = Labels)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 0, size = 10)) +
    xlab(xlab) +
    ylab("Literacy Rates (in Percent)") +
    ggtitle(title) +
    theme(plot.title = element_text(size = 50,colour = "#FF8800",family = "Times New Roman"))
  
  
}

# function for plotting literacy Status

literacy_status <- function(province){
  if(province== "overall"){
   
    data1 <- read.csv("data/literacy_status.csv")
   
    title <- "Literacy Status of Nepal"
  }else{
    data1 <- read.csv("data/Province_wise_literacy_status.csv")
    data1 <- data1 %>% filter(Province == province)
    data1 <- data1 %>% rename("category"= "Status")
    title <- paste("Literacy Status of ",province)
  }
  ggplot(data1,aes(category,Total,fill = category ))+
    geom_bar(stat = "identity")+
    ylab("Percentange")+
    xlab("Literacy Status")+
    ggtitle(title)+
    theme(plot.title = element_text(size = 50,colour = "#FF8800",family = "Times New Roman"))
}

# function for showing literacy status data
table_literacy_status <- function(province){
  if(province == "overall"){
    data1 <- read.csv("data/literacy_status.csv")
  }else{
    data1 <- read.csv("data/Province_wise_literacy_status.csv")
    data1 <- data1 %>% filter(Province == province)
    data1 <- data1 %>% select(c("Status", "Total","Male","Female"))
  }
  data1
}

# function for showing literacy rates data

table_literacy_rates <- function(province){
  if(province == "overall"){
    data1 <- read.csv("data/Province_wise_literacy_rates.csv")
  }else{
    data1 <- read.csv("data/literacy-rates.csv")
    data1 <- data1 %>% filter(Province = province)
  }
  data1
}
