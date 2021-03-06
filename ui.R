shinyUI(
  navbarPage(
    "v1.2.2", theme = shinytheme("cosmo"),
    
    tabPanel(
      "Plots",
      fluidPage(
        includeCSS("www/styles.css"),
        
        fluidRow(
          #verbatimTextOutput('debug'),
          
          column(3,
                 fluidRow(
                   
                   h3("Arrangement"),
                   
                   selectInput("Yaxis",
                               label = "Y-axis:",
                               choices = c(levels(data()$Type), 'Cell Number')
                   ),
                   
                   column(6,
                          radioButtons('group',
                                       label = 'Split plots on:',
                                       choices = c(GLSNS),
                                       selected = 'Labels')
                   ),
                   column(6,
                          
                          radioButtons('colorize',
                                       label = 'Color on:',
                                       choices = GLSN,
                                       selected = 'Genotype')
                   )
                 ),
                 
                 fluidRow(
                   
                   tags$hr(),
                   
                   h3("Graph options"),
                   
                   fluidRow(
                     
                     column(6,
                            sliderInput('plheight', label = 'Plot height', ticks = FALSE,
                                        min = 200, max = 2000, value = 600, step = 200, width = '80%')
                     ),
                     column(6,
                            sliderInput('ncols', label = 'Plots per row', ticks = FALSE,
                                        min = 1, max = 12, value = 3, step = 1, width = '80%')
                     )
                   ),
                   
                   actionButton('graphOptsBut', 'More options',
                                class = "moreOpt_style"),
                   
                   conditionalPanel(
                     "input.manualY == 1",
                     div('Manual scale selected. Values outside the selected range will not be visible',
                         style = "color:red")
                   ),
                   
                   bsModal('graphOpts', 'Graph options', 'graphOptsBut',
                           size = 'small',
                           
                           checkboxInput('manualY', 'Manually set Y-axis range'),
                           
                           conditionalPanel(
                             
                             "input.manualY == 1",
                             
                             textInput('minY', label = 'Minimum'),
                             
                             textInput('maxY', label = 'Maximum'),
                             
                             tags$hr()
                           ),
                           
                           checkboxInput('showPval', label = 'Show p-values from Kruskal–Wallis test',
                                         value = FALSE),
                           
                           checkboxInput('logY', label = 'Log y-axis',
                                         value = FALSE),
                           
                           checkboxInput('gtheme', label = 'Grey background',
                                         value = FALSE),
                           
                           helpText("Color scheme (http://colorbrewer2.org)"),
                           
                           selectizeInput('brewery', label = NULL,
                                          choices = 'Dark2'),
                           
                           checkboxInput('customcol', label = 'Use custom color mode for cell types',
                                         value = TRUE)
                   ),
                   
                   tags$hr(),
                   
                   conditionalPanel("input.tabs1 == 'histogram'", class = 'panel_style',
                                    
                                    h3('Histogram options'),
                                    
                                    radioButtons('density', label = 'Y-axis:',
                                                 choices = c('counts', 'density'),
                                                 selected = 'density'),
                                    
                                    sliderInput('bin', label = 'Number of bins', ticks = FALSE,
                                                min = 2, max = 100, value = 40,
                                                step = 2, width = '60%')
                   ),
                   
                   
                   conditionalPanel("input.tabs1 == 'scatter'",
                                    class = 'panel_style',
                                    
                                    h3('Scatterplot options'),
                                    
                                    checkboxInput('interact', label = 'Interactive plot (slower)',
                                                  value = FALSE)
                   )
                 ),
                 
                 fluidRow(
                   
                   h3("Data selection"),
                   
                   actionButton('setCellsBut', 'Set cell types',
                                class = "moreOpt_style"),
                   
                   tags$hr()
                   
                 ),
                 
                 fluidRow(
                   
                   column(6,
                          
                          checkboxGroupInput('Genotype',
                                             label = 'Genotypes',
                                             choices = levels(data()$Genotype),
                                             selected = levels(data()$Genotype)
                          ),
                          
                          strong('Tags'),

                          checkboxInput('SMCneighb',
                                        label = 'Use only SMC neighbour cells',
                                        value = FALSE)
                   ),
                   column(6,
                          
                          checkboxGroupInput('Stage',
                                             label = 'Stages',
                                             choices = levels(data()$Stage),
                                             selected = levels(data()$Stage)
                          ),
                          
                          actionButton('Stage_goButton', 'select all',
                                       class = 'actbut_style', width = '60%')
                   )
                 )
          ),
          
          column(9,
                 
                 tabsetPanel(id = 'tabs1',
                             
                             tabPanel('boxplot',
                                      
                                      uiOutput('UIgetpdf_bx'),
                                      plotOutput('plotBoxplot')
                             ),
                             
                             tabPanel('scatter',
                                      
                                      conditionalPanel("input.interact == false",
                                                       uiOutput('UIgetpdf_jit'),
                                                       plotOutput('plotJitter')
                                      ),
                                      
                                      conditionalPanel("input.interact == true",
                                                       plotlyOutput('jitter_i', height = 'auto'),
                                                       #textOutput("selectTable")
                                                       dataTableOutput("selectTable")
                                      )
                             ),
                             
                             tabPanel('histogram',
                                      
                                      uiOutput('UIgetpdf_h'),
                                      plotOutput('plotHist')
                             ),
                             
                             tabPanel('means',
                                      
                                      helpText('Error bars represent the standard error of the mean.'),
                                      fluidRow(
                                        actionButton('MeanTabButton', label = 'View as table',
                                                     class = 'downloadBut_style')
                                      ),
                                      
                                      fluidRow(uiOutput('UIgetpdf_mn')
                                      ),
                                      bsModal('tabMeansMod', 'Mean ± SD', 'MeanTabButton',
                                              dataTableOutput('tableMeans'),
                                              helpText('Download as a .CSV file'),
                                              downloadButton('downloadTableMeans', 'Download')
                                      ),
                                      plotOutput('plotMeans')
                             ),
                             
                             tabPanel('table',
                                      
                                      dataTableOutput('gg_data_table'),
                                      helpText('Download table as a .CSV file'),
                                      downloadButton('download_gg_data', 'Download')
                             )
                 )
          )
        )
      )
    ),
    
    tabPanel("Data",
             
             fluidPage(
               tabsetPanel(id = 'tabs2',
                           tabPanel('Original data', dataTableOutput("alldata")),
                           tabPanel('Total stacks', dataTableOutput('cell_numb_stack'))
               )
             )
    )
  )
)
