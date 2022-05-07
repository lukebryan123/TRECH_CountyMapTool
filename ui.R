
fluidPage(
  fluidRow(column(2),
           column(8, p("Fossil fuel-based air pollution presents a significant threat to the health of people across the globe. Here at the TRECH Project, we have been studying (9) policy scenarios designed to reduce the impact air pollution has on our lives and communities.
                        The units for this app are in annual prevention, meaning larger numbers signify more lives saved and diseases prevented. Use either the interactive map or plots to compare policies."),
                        style="color:black;text-align:center;white-space:pre-line")),
  fluidRow(
    column(2),
    column(4, selectInput("policy", "Policy", list( `20% option` = list("20% Diversified", "20% Hybrid", "20% Max GHG"),
                                                    `22% option` = list("22% Diversified", "22% Hybrid", "22% Max GHG"),
                                                    `25% option` = list("25% Diversified", "25% Hybrid", "25% Max GHG")),
                          selected = "25% Hybrid"), align = "center"),
    column(4, selectInput("ho", "Health Outcome", 
                          list(`Deaths` = list("Total Deaths", "Particulate Matter Deaths", "Ozone Deaths", "NO2 Deaths"),
                               `Hospitalizations` = list("Total Hospitalizations", "Cardio-Vascular Hospitalizations", "Respiratory Hospitalizations", "Asthma Hospitalizations"),
                               `ER Visits` = list("Total ER Visits","Cardio-Vascular ER Visits", "Respiratory ER Visits", "Asthma ER Visits"),
                               `Asthma` = list("New Asthma Cases", "Asthma Attacks"),
                               `Other Health Effects` = list( "Heart Attacks","Low Birth Weight Cases", "Preterm Births", "Autism Spectrum Disorder Cases", 
                                                              "Lower Respiratory Infections", "Bronchitis Cases"))),
           align = "center"),
    column(2)
  ),
  mainPanel(width = 12,
            tabsetPanel(
              tabPanel("Health Effects", leafletOutput("er", height = 650)),
              tabPanel("Bar Plot", fluidRow(
                column(6, plotOutput("col", height = 500)),
                column(6, plotOutput("bar"))))))
)
