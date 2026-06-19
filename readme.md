# Nepal Census Data Visualization Dashboard

An interactive R Shiny application for exploring and visualizing Nepal’s census data across multiple administrative levels. The dashboard transforms raw demographic datasets into an intuitive analytical interface with dynamic charts, tables, and summaries.

---

## Overview

This project provides an interactive platform to analyze Nepal’s population and housing census data. Users can explore demographic indicators across:

- National level (Nepal)
- Province level
- District level
- Local level (Municipality / Rural Municipality)

The dashboard supports exploration of population distribution, household structure, gender composition, literacy statistics, and historical population trends.

---

## Features

- Hierarchical geographic filtering (Province → District → Local Level)
- Dynamic population visualizations
- Household distribution analysis
- Gender composition (pie chart)
- Literacy rate and literacy status analysis
- Historical population trend visualization (1911–2011 census data)
- Tabular demographic summaries
- Reactive updates based on user input

---

## Technologies Used

### Core Language
- R Programming Language

### Framework
- Shiny (Interactive web applications)

### Libraries
- ggplot2 – Data visualization
- dplyr – Data manipulation
- shiny – Web app framework

---


---

## How It Works

The application follows a reactive workflow:

1. User selects a geographic level (province/district/local level)
2. Inputs are captured by Shiny
3. Dataset is filtered dynamically
4. Summary statistics are computed
5. Visualizations and tables update automatically

This ensures real-time responsiveness without manual refresh.

---

## Data Sources

### 1. 2021 Census Dataset
Contains:
- Province, district, and local-level identifiers
- Total population
- Male and female population
- Number of households and families

### 2. Historical Census Dataset (1911–2011)
Used for:
- Long-term population trend analysis
- Intercensal growth visualization

---

## Key Modules

### Population Analysis
- Aggregates population by administrative level
- Displays comparative bar charts

### Household Analysis
- Visualizes household distribution across regions

### Gender Distribution
- Pie chart representation of male vs female population

### Literacy Analysis
- Literacy rate comparisons across regions
- Literacy classification (literate / non-literate)

### Trend Analysis
- Historical population growth over time
- Intercensal change visualization

### Miscellaneous Indicators
- Marital status distribution
- Additional demographic summaries

---

## Core Functions

- `deduce()` – Handles hierarchical data transformation based on user selection
- `chart()` – Generates population visualizations
- `chart_house()` – Household distribution charts
- `literacy_rates()` – Literacy rate analysis
- `literacy_status()` – Literacy classification
- `intercensal()` – Historical population trend analysis
- `chart_others()` – Additional demographic visualizations

---

