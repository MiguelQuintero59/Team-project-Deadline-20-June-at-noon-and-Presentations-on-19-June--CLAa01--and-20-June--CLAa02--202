load_gene_subset <- function(group_number,
                             expression_file = "gene-expression-invasive-vs-noninvasive-cancer.csv",
                             subset_file = "teamsubsets.csv",
                             include_class = TRUE) {
  library(dplyr)
  library(caret)
  library(glmnet)
  library(ggplot2)
  library(reshape2)
  library(pheatmap)
  library(MASS)

  # Load main dataset
  dataframe <- read.csv(file = expression_file)

  # Load subset file
  df_subsets <- read.csv(file = subset_file, sep = ' ')

  # Filter by group number
  reg_id <- df_subsets[group_number, ]

  # Extract gene indices (remove the ID column)
  subsets <- as.numeric(reg_id[-1])

  # Filter gene expression dataframe using selected gene indices
  df <- dataframe[, subsets]

  # Optionally, add class and cancer type
  if (include_class) {
    df$Class <- dataframe$Class
  }

  return(df)
}

# Initialize empty results data frame
results_table <- data.frame(
  Model = character(),
  Hyperparameter = character(),
  Precision = numeric(),
  Sensitivity = numeric(),
  Specificity = numeric(),
  stringsAsFactors = FALSE
)

#QUESTION 1
# Feature subset selection is the process of identifying and removing as much irrelevant and redundant information as possible. 