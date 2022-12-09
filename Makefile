.PHONY: clean

clean:
	rm -f figures/*
	rm -f derived_data/*
	rm -f Report.pdf

#.created-dirs:
	#mkdir -p figures

#derived_data
derived_data/african_crises_derived.csv: data_pretreatment.R source_data/african_crises.csv
	Rscript data_pretreatment.R

# model information
derived_data/model.RData: model.R derived_data/african_crises_derived.csv
	Rscript model.R

# figures
figures/nsystemic_by_year.png figures/systemic_crisis_by_year_country.png figures/systemic_crisis_count.png figures/systemic_currency.png figures/systemic_independence.png figures/systemic_inflation_crises.png figures/systemic_banking_crisis.png figures/systemic_sovereign_external_debt_default.png figures/systemic_domestic_debt_in_default.png figures/systemic_exch_usd.png figures/correlation_plots.png: summary_plots.R derived_data/african_crises_derived.csv
	Rscript summary_plots.R

figures/rf_var_importance_plot.png figures/rf_ROCit_obj.png: model.R derived_data/african_crises_derived.csv
	Rscript model.R

# report
report.pdf: Report.Rmd figures/systemic_crisis_by_year_country.png figures/systemic_crisis_count.png figures/systemic_currency.png figures/systemic_independence.png figures/systemic_inflation_crises.png figures/systemic_banking_crisis.png figures/systemic_sovereign_external_debt_default.png figures/systemic_domestic_debt_in_default.png figures/systemic_exch_usd.png figures/rf_var_importance_plot.png figures/rf_ROCit_obj.png risk_prediction_system.png figures/correlation_plots.png
	Rscript -e "rmarkdown::render('Report.Rmd')"
	
shiny: shiny_app.R derived_data/model.RData
	Rscript shiny_app.R
