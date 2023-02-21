# Linear-Regression-Project

Project: How Much Does Economic Inequality Affect Suicide Rates in OECD Countries?

Our group sought to investigate potential factors that might have a relation with a country’s suicide rate.
To look at this potential relationship, we looked at cross-sectional data from countries that are a part of the Organization for Economic Cooperation and Development (OECD). This group of 38 countries is characterized as being highly developed and having high income. We gathered data on economic and lifestyle variables. Examples of the economic factors include the democracy index and human capital, while some examples of lifestyle factors were alcohol consumption and marriage rate. After gathering and cleaning the cross-section data, we built linear regression models to examine possible relationships.

Null Hypothesis: Economic inequality has no effect on OECD suicide rates.
Alternative Hypothesis: Economic inequality has a significant effect on OECD suicide rates.

Conclusion:
The impact from economic inequality on suicide rates in OECD countries is not significant. There exists a mediator “alcohol” which could explain the negative coefficient of Gini in the economic model.
![image](https://user-images.githubusercontent.com/43702115/220267178-41870adb-8abc-4ea5-ae05-a556a7582254.png)
Chart 4.1 Alcohol as a mediator

Why do we regard alcohol as a mediator? According to the correlation coefficients, we could tell that the Gini coefficent and alcohol are highly correlated. Besides, alcohol and suicide rate are highly correlated as well. Below are two scatter plots showing these two correlations.

![image](https://user-images.githubusercontent.com/43702115/220267259-712d11cd-fc10-4f07-ac77-75e511974d08.png)

Chart 4.2 Correlation between log(Gini) and alcohol

 ![image](https://user-images.githubusercontent.com/43702115/220267302-9ca81368-c2c5-48bf-a944-c743b9bd86d5.png)
 
Chart 4.3 Correlation between alcohol and suicide rate

In chart 4.2, we can see that when log(Gini) decreases, alcohol consumption increases. Chart 4.3 tells us that suicide rate increases when alcohol consumption increases. So in summary, the Gini coefficient has a reverse correlation (though not significant) with suicide rate, which corresponds to the negative coefficient -9.05 in the economic model.

One plausible explanation for the first correlation is that when the Gini coefficient is low, wealth is more evenly distributed and social class is more stable. People tend to be not aggressive and spend more money enjoying their lives and consume more alcohol. However, this is just a hypothesis. The truth needs further research and discussion. 

There are a lot of accepted reasons why alcohol increases suicide rate, but alcohol is not our main point in this research. So we will not discuss them in this report.

Under these circumstances, we recommend governments to focus on lifestyle variables such as alcohol consumption to decrease the suicide rate, rather than concentrate on economic variables. Lifestyle is a more direct factor to suicide rate than economic inequality, which in fact, acts as a mediator between economic factors and suicide rate.
