# EconoMining
Text mining thecniques applied in economic literature.

This project aims to provide some templates for using text mining in economic literature. At a first glance, it's seems that the economy subject should not be specified in the project, due to the fact that the thecniques here shown can be used in any other kind of literature. Nonetheless, this kind of approach will be helpful for gathering a specific public (e.g: researchers in economics), who can provide thoroughly feedbacks and thoughts for attending that specific field of knowledge.

At the beginning, I'll only use R but I'm willing to work with *Python* and *JS* (in the future) too. Maybe, due to some [shiny](https://shiny.rstudio.com/tutorial/) issues/features (or maybe due to a lack of knowledge from my part LOL) there will be two or more repositories for *EconoMining* as I build more than one app for this project.

## Word clouds from Adam Smith's "Wealth of the Nations"

This initial project it's a web scrapping from Adam Smith's  'An Inquiry into the Nature and Causes of the Wealth of Nations (1776)' followed by a word cloud. The link source is "https://www.econlib.org/library/Smith/smWN.html?chapter_num=8#book-reader", and the task was build under a shiny app avaliable in the repository. The reader will find through an example from economic sciences how to webscrap an webpage using `rvest` package from R, `tm` package for aplying text mining techniques and `wordcloud` package to plot an wordcloud. If you want to run this app, you should run this in your *R* console: 

`shiny::runGitHub("rafoonico/EconoMining","rafoonico")`

And please be sure that you have these packages: `install.packages(c("shiny","rvest","magrittr","tm","wordcloud"))`
