# Project Two
 
This study utilizes a national dataset of 996 infants with severe Bronchopulmonary Dysplasia (sBPD) from 10 centers, focusing on demographics, diagnostics, and respiratory parameters at 36 and 44 weeks post-menstrual age to predict if an infant should receive a tracheostomy. Concerns arise from a disproportionate center representation, potential biases, and notable tracheostomy percentage variations among centers.

Variable selection identifies significant covariates, emphasizing prenatal corticosteroids, small for gestational age (SGA), inspired O2, medication for pulmonary hypertension (PH), and invasive positive pressure. Correlation analyses guide the exclusion of correlated metrics, and missing data patterns prompt careful imputation considerations.

Fixed effects models and mixed-effects models, acknowledging center-level variation, reveal consistent predictors in both 36 and 44-week models. Evaluation metrics favor the 44-week model, indicating superior predictive accuracy, precision, and recall. Surprisingly, the addition of a random intercept for center minimally affects model performance on validation data, suggesting limited center-level variation.

This study emphasizes the complexity of predicting tracheostomy in sBPD infants, providing direction for future predictive models for tracheostomy.

## Directory
* EDA.R: the code outlining all the exploratory data analysis performed, including plots/figures that did not make it into the final analysis.
* Project_Two.Rmd: the .Rmd file including all the code and text from the analysis.
* Project_Two.pdf: the exported .pdf file.
* references.bib: the references used in this analysis, in the BibTex format.

## Acknowledgements

This analysis has been performed with help from Dr. Christopher Schmid from the School of Public Health at Brown University and Dr. Robin McKinney Alpert Medical School at Brown University.
