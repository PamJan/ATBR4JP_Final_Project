library(shiny)
# library for using API
library(httr)
# library for using and parsing json
library(jsonlite)

shinyServer(function(input, output, session) {
  # this function is listening for event "search" from UI -> clicking button "Search"
  observeEvent(input$search, {
    # function will stop rest of the script if the "input$compound_name" is not given
    req(input$compound_name)
    
    # creating variable "compound_name" received from UI - the text input from
    compound_name <- input$compound_name
    
    # encoding by function URLencode for use in the URL and creating variable "encoded_name"
    # it is important for example for " " because they are permited in url
    # instead they are encoded by "%20"
    encoded_name <- URLencode(compound_name)
    
    # using the PubChem API to search for the compound
    search_url <- paste0("https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/", encoded_name, "/property/MolecularWeight,Title,MolecularFormula,CanonicalSMILES,ExactMass,XLogP,TPSA,HBondDonorCount,HBondAcceptorCount,RotatableBondCount/JSON")
    search_response <- GET(search_url)
    
    # data receive from API is not only "PropertyTable" we asked for
    # it is also: "https", "Date", "Status", "Content-type" and "size"
    # we dont need that information so we parse that json to only vector with "PropertyTable" that we have "Properties"
    search_data <- content(search_response, "parsed", simplifyVector = TRUE)
    
    # when properties exist that mean that we make query to existing compund
    # if not we make a spelling mistake or that compund doesnt exist in PubChem
    if (!is.null(search_data$PropertyTable$Properties)) {
      # if it exist we create new variable "properties" with recieved properties from API
      properties <- search_data$PropertyTable$Properties
      
      # Now we will extract properties to responding variables
      molar_mass <- properties$MolecularWeight
      title <- properties$Title
      formula <- properties$MolecularFormula
      smiles <- properties$CanonicalSMILES
      exact_mass <- properties$ExactMass
      xlogp <- properties$XLogP
      tpsa <- properties$TPSA
      h_bond_donors <- properties$HBondDonorCount
      h_bond_acceptors <- properties$HBondAcceptorCount
      rotatable_bonds <- properties$RotatableBondCount
      
      # To get a image of compound we need to make different query (image is not property in API)
      image_url <- paste0("https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/", encoded_name, "/PNG")
      
      # now we make endpoint for UI that it will use to display "compound_image"
      # for image we need to use function "renderUI"
      output$compound_image <- renderUI({
        # src is the path for the image -> from API
        # style = "width:100%;" mean that image will be scalable with window width 
        tags$img(src = image_url, style = "width:100%;")
      })
      
      # for the rest we will make endpoints for UI that will be displayed using function "renderText"
      # inside function "paste" there is short description and property from API
      output$molar_mass <- renderText({
        paste("Molar Mass:", molar_mass)
      })
      output$description <- renderText({
        paste("Description:", title)
      })
      output$chemical_formula <- renderText({
        paste("Chemical Formula:", formula)
      })
      output$canonical_smiles <- renderText({
        paste("Canonical SMILES:", smiles)
      })
      output$exact_mass <- renderText({
        paste("Exact Mass:", exact_mass)
      })
      output$xlogp <- renderText({
        paste("XLogP:", xlogp)
      })
      output$tpsa <- renderText({
        paste("TPSA:", tpsa)
      })
      output$h_bond_donors <- renderText({
        paste("Hydrogen Bond Donors:", h_bond_donors)
      })
      output$h_bond_acceptors <- renderText({
        paste("Hydrogen Bond Acceptors:", h_bond_acceptors)
      })
      output$rotatable_bonds <- renderText({
        paste("Rotatable Bonds:", rotatable_bonds)
      })
    } else {
      # if property doesnt exist we will send to UI information that "No compound found"
      # so rest properties will be "N/A"
      output$compound_image <- renderUI({
        tags$p("No compound found")
      })
      output$molar_mass <- renderText({
        "Molar Mass: N/A"
      })
      output$description <- renderText({
        "Description: N/A"
      })
      output$chemical_formula <- renderText({
        "Chemical Formula: N/A"
      })
      output$canonical_smiles <- renderText({
        "Canonical SMILES: N/A"
      })
      output$exact_mass <- renderText({
        "Exact Mass: N/A"
      })
      output$monoisotopic_mass <- renderText({
        "Monoisotopic Mass: N/A"
      })
      output$xlogp <- renderText({
        "XLogP: N/A"
      })
      output$tpsa <- renderText({
        "TPSA: N/A"
      })
      output$h_bond_donors <- renderText({
        "Hydrogen Bond Donors: N/A"
      })
      output$h_bond_acceptors <- renderText({
        "Hydrogen Bond Acceptors: N/A"
      })
      output$rotatable_bonds <- renderText({
        "Rotatable Bonds: N/A"
      })
    }
  })
})
