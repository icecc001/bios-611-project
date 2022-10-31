.PHONY: clean

clean:
	rm -rf figures

.created-dirs:
	mkdir -p figures

# figures
figures/randomforest_varimp.png: model.R source_data/african_crises.csv
	Rscript model.R

report.pdf: Report.Rmd figures/randomforest_varimp.png
	Rscript -e "rmarkdown::render('Report.Rmd')"





