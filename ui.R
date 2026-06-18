#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(ggplot2)
library(fontawesome)

shinyUI(
  dashboardPage(title = "Data Visualization",
    dashboardHeader(title = "Data visualization"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Population Census 2078",tabName = "overall",icon = icon("users")),
        # selectInput("province","Province",choices = c("Select Province"= "overall", 
        #                                               "Koshi"= "Koshi",
        #                                               "Madesh"= "Madesh",
        #                                               "Bagmati"= "Bagmati",
        #                                               "Gandaki"="Gandaki",
        #                                               "Lumbini"= "Lumbini",
        #                                               "Karnali"= "Karnali",
        #                                               "Sudurpaschim"= "Sudurpaschim"
        #                                               )),
        # uiOutput("dis"),
        # uiOutput("localLevel"),
        
        menuItem("Population Trend", tabName = "trend",icon = icon("chart-line")),
        menuItem("Educational Status 2078",tabName = "edu",icon = icon("graduation-cap")),
        menuItem("Others/ Miscellaneous",tabName = "others"),
        menuItem("About",tabName = "abouts")
      )
    ),
    dashboardBody(title = "Dashboard",
      
      
      
     tabItems(
       tabItem(tabName = "overall",
              fluidRow( 
                               box(title = "Select the Adminsistration",status = "warning",solidHeader = T,width=12,height = 150,
                                   column(width= 4 ,
                                     selectInput("province","Province",choices = c("Select Province"= "overall", 
                                                                 "Koshi"= "Koshi",
                                                                 "Madesh"= "Madesh",
                                                                 "Bagmati"= "Bagmati",
                                                                 "Gandaki"="Gandaki",
                                                                 "Lumbini"= "Lumbini",
                                                                 "Karnali"= "Karnali",
                                                                 "Sudurpaschim"= "Sudurpaschim" )
                                                )),
                          column(width = 4, 
                                 uiOutput("district")
                              ),
                          column(width = 4,
                                 uiOutput("localLevel")
                          )
                  )),
              
              box(strong(h3(uiOutput("highlights"))),width = 12,height = 100
                  ),
              box(width = 12,height = 100,
               column(width =4,
                 box(title= "Total Population",status = "primary",solidHeader=T,textOutput("total"))
               ),
              column(width=4,
                 box(title= "Total Male",status = "primary",solidHeader=T,textOutput("male"))
              ),
              column(width = 4,
                 box(title= "Total Female",status = "primary",solidHeader=T,textOutput("female"))
              )),
               
            tabsetPanel(type = "tab",id = "tab1",
              tabPanel("Visualization",
                plotOutput("overall"),
                hr(),
                fluidRow(
                column(width = 6,
                plotOutput("cake")),
                
                column(width =6,
                plotOutput("house"))
              )),
              tabPanel("Data",
                box(tableOutput("table"),width = 12.5),
                hr()
              )
            )
       ),
       tabItem(tabName = "edu",
               box(title = "Select Administration", solidHeader = T,status = "warning",width = 9,
                   fluidRow(  selectInput("province1","Province",choices = c("Select Province"= "overall", 
                                                                             "Koshi"= "Koshi",
                                                                             "Madesh"= "Madesh",
                                                                             "Bagmati"= "Bagmati",
                                                                             "Gandaki"="Gandaki",
                                                                             "Lumbini"= "Lumbini",
                                                                             "Karnali"= "Karnali",
                                                                             "Sudurpaschim"= "Sudurpaschim" )
                                          )
                              )
                   ),
            tabsetPanel(type = "tab", id = "tab2",
                        tabPanel("Visualization",
                             plotOutput("literacy_status"),
                        plotOutput("literacy_rates")),
                        tabPanel("Data",
                                 h3(strong("Literacy Status Table")),
                                 tableOutput("literacy_status_t"),
                                 h3(strong("Literacy Rates Table")),
                                 tableOutput("literacy_rates_t")
                                 )
                        )
                             
                                   
                  ),
      
       tabItem(tabName = "trend",
               fluidRow(
                 # splitLayout(cellWidths = c("45%", "45%"),
                  column(width =6,
                        plotOutput("trend_pop")
                        ),
                  column(width = 6,
                       plotOutput("growth")
                 )
               )
           ),
       tabItem(tabName = "others",
               box(title = "Select the Category",status = "warning",solidHeader = T,width=6,height = 150,
                   selectInput("visual","Data",choices = c("Select data"= "overall", 
                                                            "Maritial Status"="maritial" )
                   )
                   
               ),
               
               tabsetPanel(type="tab",id = "tab2",
                          tabPanel("Visualization",
                                    plotOutput("others")
                                  ),
                          tabPanel("Data",
                                    tableOutput("others_t")
                                  )
            )
       ),
       tabItem(tabName = "abouts",
               h1("Developed by:"),br(),
               h3("Ashok Jaishi"),br(),
               h3("Bishal Bhandari"), br(),
               h3("Milan Baral"), br(),
               h3("Mukunda Rijal"),br()
               
               )
     )
    )
  )
)

  
  
