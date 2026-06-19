Documentation: Nepal Census Data Visualization Dashboard
1. Project Overview

This project is an interactive web-based dashboard developed using R Shiny that provides a visual exploration of Nepal’s population and demographic statistics. The application uses census datasets to allow users to interactively analyze population distribution, household information, literacy status, literacy rates, population trends, and other demographic characteristics.

The main objective of this dashboard is to transform raw census data into a user-friendly interface where users can select geographical levels and instantly view summarized information through charts, tables, and key statistics.

The application is designed around Nepal’s administrative hierarchy:

Nepal (National level)
Province
District
Local Level

Users can navigate between these levels and analyze population characteristics based on their selection.

2. Technologies Used

The application is developed using:

R Programming Language

Used for:

Data processing
Statistical calculations
Visualization
Application logic


R Shiny Framework

Used for:

Creating the interactive web interface
Handling user inputs
Dynamically updating outputs
R Packages

shiny

Provides the framework for building interactive web applications.

ggplot2

Used for creating statistical visualizations such as bar charts and line graphs.

dplyr

Used for data manipulation, filtering, grouping, and summarizing census information.
3. Application Workflow

The application follows a reactive programming structure.

The general workflow is:

User Selection
        |
        ↓
Input values captured by Shiny
        |
        ↓
Data filtered according to selection
        |
        ↓
Summary statistics generated
        |
        ↓
Charts and tables updated automatically

Whenever the user changes a selection, the application recalculates the required information and updates the displayed results.

4. Data Loading

The application loads census data from CSV files stored inside the data folder.

Main dataset:

preliminary-data-of-national-population-and-housing-census-2021-english2.csv

This dataset contains information related to:

Province
District
Local Level
Total population
Male population
Female population
Number of households
Number of families

The data is loaded when the server starts:

data1 <- read.csv("data/preliminary-data-of-national-population-and-housing-census-2021-english2.csv")
5. Dynamic Location Selection

The dashboard provides three levels of selection.

Province Selection

The user first selects a province.

Based on this choice, the district dropdown is automatically updated.

Example:

Selecting:

Bagmati Province

will display only districts belonging to Bagmati Province.

District Selection

After selecting a district, the local-level dropdown is updated.

Example:

Selecting:

Kathmandu District

will show available municipalities inside Kathmandu.

Local Level Selection

The user can finally select a municipality or rural municipality to view detailed statistics.

6. Data Processing Function
deduce()

Purpose:

The deduce() function is responsible for transforming raw census data into a format suitable for visualization.

It adjusts the data according to user selection.

The function handles four situations:

1. National Level

If the user selects Nepal:

Data is grouped by province.

Output:

Population by province
Household numbers
Male population
Female population
2. Province Level

If a province is selected:

Data is grouped by district.

Output:

District-wise population information.

3. District Level

If a district is selected:

Data is grouped by local level.

Output:

Municipality-wise statistics.

4. Local Level

If a specific municipality is selected:

The function returns detailed information for that area.

7. Population Visualization
chart()

This function creates population bar charts.

Depending on the selected level, it displays:

Population by Province
Population by District
Population by Local Level

The chart includes:

X-axis: Geographic area
Y-axis: Population count
Dynamic title

Example:

Population by Province
8. Household Visualization
chart_house()

This function generates household comparison charts.

It shows:

Number of households by province
Number of households by district
Number of households by local level

This helps compare settlement patterns across different regions.

9. Gender Distribution

The application displays a pie chart showing male and female population distribution.

The calculation is performed using:

sum(data2$total.male)
sum(data2$total.female)

The result provides a quick overview of gender composition.

10. Population Trend Analysis
intercensal()

This function visualizes historical population changes.

It uses:

inter-censal-population-changes-from-1911-to-2011-ad.csv

Two types of trends are available:

Population Trend

Shows Nepal’s population growth across census years.

Intercensal Growth

Shows changes between census periods.

The visualization uses line graphs to show long-term demographic patterns.

11. Literacy Analysis Module

The education section contains two major components.

Literacy Rate

Function:

literacy_rates()

Purpose:

Displays literacy percentage by:

Province
District
Literacy Status

Function:

literacy_status()

Purpose:

Shows population classification based on literacy condition.

It supports:

National literacy status
Province-wise literacy status
12. Miscellaneous Data Module

The miscellaneous section provides additional demographic analysis.

Currently supported:

Marital Status

Function:

chart_others()

Displays marital status distribution using census information.

The related table is generated using:

table_others()
13. Output Components

The dashboard contains several output elements.

Text Outputs

Examples:

Total population
Male population
Female population
Graphical Outputs

Examples:

Population bar chart
Household chart
Gender pie chart
Literacy graphs
Population trend graphs
Tables

Users can view the processed census data directly in tabular form.

14. Advantages of the Application

This dashboard provides:

Interactive census data exploration
Faster understanding of demographic patterns
Geographic comparison of population statistics
Visual representation of large datasets
Easy access for non-technical users

Instead of manually analyzing CSV files, users can explore census information through an interactive interface.

15. Future Improvements

Possible improvements include:

1. Adding Maps

Integration with packages such as:

leaflet
sf

could allow geographic visualization.

2. More Statistical Analysis

Additional features could include:

Population density analysis
Migration analysis
Growth prediction models
3. Improved User Interface

The dashboard could be enhanced with:

Better navigation
Custom themes
Interactive charts using plotly
Conclusion

This project demonstrates how R Shiny can be used to convert large census datasets into an interactive analytical dashboard. By combining data processing, statistical visualization, and reactive programming, the application provides an accessible platform for exploring Nepal’s demographic information.