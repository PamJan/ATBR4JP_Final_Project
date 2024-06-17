library(shiny)

shinyUI(fluidPage(
  # Creating style - something like css
  tags$style(HTML("
    .column-bg {
      background-color: #e6f7ff; /* light blue background color */
      padding: 10px; /* padding for spacing */
      height: 380px; /* setting height for columns */
      overflow-y: auto; /* creating vertical scrollbar, if content overflows */
      border-right: 1px solid #b3e0ff; /* adding blue right border to all columns*/
    }
  ")),
  #creating sidebar
  sidebarLayout(
    sidebarPanel(
      # creating text input that will sent "compound_name" to server site
      # with tittle "Enter Compound Name" 
      textInput("compound_name", "Enter Compound Name"),
      # creating button tat will make event "search" on click (this event will be handled on the server site)
      # with title "Search"
      actionButton("search", "Search"),
      # create place that will receive "compound_image" from server site and display it
      uiOutput("compound_image")
    ),
    # creating main panel next to the side bar
    mainPanel(
      fluidRow(
        # create first column with width 4, and "css" class "column-bg"
        column(4, class = "column-bg",
               # creating headline for first column - "Basic Information"
               h4("Basic Information"),
               # displaying text recited form server site - "description"
               textOutput("description"),
               # new line
               br(),
               # displaying text recited form server site - "molar_mass"
               textOutput("molar_mass"),
               # new line
               br(),
               # displaying text recited form server site - "chemical_formula"
               textOutput("chemical_formula"),
               # new line
               br(),
               # received text sometimes is to large for column so it will go to next line if it overflow
               div(style = "overflow-wrap: break-word;",
                   # displaying text recited form server site - "canonical_smiles"
                   textOutput("canonical_smiles"))
        ),
        # the following columns work similar
        column(4, class = "column-bg",
               h4("Mass and Properties"),
               textOutput("exact_mass"),
               br(),
               textOutput("xlogp"),
               br(),
               textOutput("tpsa")
        ),
        column(4, class = "column-bg",
               h4("Chemical Properties"),
               textOutput("h_bond_donors"),
               br(),
               textOutput("h_bond_acceptors"),
               br(),
               textOutput("rotatable_bonds")
        )
      )
    )
  )
))
