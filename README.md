# [StoicKit v0.0]
---
## Todo
- [ ] Complete API Guide
- [ ] Decouple related Application's source into this SP
- [ ] Setup tooling for Generative forecasting
- [ ] Accurate comments and explanations behind indicators calculations

## Intro

This Kit will not only be an API for time-series manipulation, but introduce a method of generative forecasting backed by research and theory. I have yet to have my draft peer-reviewed, but I feel relaying some of my thoughts and citations through an open-source project and an App could lead to such. If the community is willing to help in proving my theory is right that would be ideal, but even simply attributing these thoughts to their own interpretations is great as well.

**Table of Contents**
- [Goals](#goals)
- [Requirements](#requirements)
- [API](#api)
- [Hypothesis](#hypothesis)
- [Research](#research)
- [Outdated](#outdated)

## Goals
- Providing back-test results at scale.
- Understanding a securities' expected trend for the following trading days.
- Adapting data analysis to personal trading strategies. To either validate one's own existing premonitions or in creating new ones.
- Developing a sharper sense of technical indicators via handling the expectations of various combinations that would lead to a manually drawn hypothesis of a securities' future.

## Requirements
WIP

## API
WIP

## Hypothesis

The major thought behind my theory, is that time-series prediction will most likely never be perfectly accurate. Reaching up to 5-10% error, at least with methods that are publicly researchable. Maybe the gap, is a *missing* *platform* in which daily fine-tuned models are generated constantly by a large community to compare data and then in realtime forecasts are adjusted. A more structured approach to "sentiment/intention".

## Research
Indicators | [Stoch D.](https://www.investopedia.com/articles/technical/073001.asp) | [Stoch K.](https://www.investopedia.com/articles/technical/073001.asp) | [MacD](https://www.investopedia.com/terms/m/macd.asp) | [EWA](https://www.investopedia.com/terms/e/ema.asp) | [SMA](https://www.investopedia.com/terms/s/sma.asp) | [Vol. Change](https://www.investopedia.com/articles/technical/02/091002.asp) | [RSI](https://www.investopedia.com/terms/r/rsi.asp) 
--- | --- | --- | --- |--- |--- |--- |--- 
***[Volatility](https://www.investopedia.com/terms/v/volatility.asp)*** |  |  |  |  |  |  |  
***[Momentum](https://www.investopedia.com/terms/m/momentum.asp)*** |  |  |  |  |  |  |  |  
***[Change](https://www.investopedia.com/terms/c/change.asp)*** |  |  |  |  |  |  |  |  
***[VWA](https://www.investopedia.com/terms/v/vwap.asp)*** |  |  |  |  |  |  |  |  

An easy way to visualize what is happening is by creating a simple matrix like the table above. The left most side, has indicators that we refer to as the ***Defaults***. These indicators will never change, and are defined as stable pivots that will support the distinctions the machine draws from 2 of the indicators we see on the top most columns.

Each node-link diagram is a representation of 2 of the ***NOT***-default indicators that were picked with the 4 ***default*** indicators predicting the closest price of the last known available price for the chosen security.

**Citations:**
Default Indicators: **[Princeton](https://www.cs.princeton.edu/sites/default/files/uploads/saahil_madge.pdf)**

#### What does this mean?

In the scatter plot, we see every individual iterations our ***Support Vector Machine*** went through and their outcomes versus the actual price of the security. Lot's of predictions heavily weighed towards one end can show a clear trend building up in the future for the stock's price. If there's many dots below the ***green line*** we can expect a fall in price, and vica versa.

The indicators chosen to be paired with the ***default*** indicators, can tell us why. 

#### Meaning

If ***RSI*** and ***Stochastic D.*** were chosen to support the default indicators, we can tell that the security has clear patterns relative to ***momentum*** within the days chosen to train that particular model.

That is because, RSI or (Relative Strength Index), is a momentum indicator. It identifies the bias an order book has, either towards buyers or sellers, the same goes with Stochastic D.. Stochastic D., is a moving average of the Stochastic K. sometimes more precise when identifying momentum changes. It's not a surprise if these 2 were paired, because Stochastics also identifies the over buying or selling nature of a particular security. Except in different way, like getting a paper peer reviewed by 2 different parties, whom both end up with the same critique. Inadvertently defininf the paper's conciseness and accurateness, validating each reviewer and the writer itself simultaneously.

#### Days?

Each indicator requires a common variable. The days to look back into the past in determining the value of the indicator to your target date. So a ***Stochastic K. 14*** of today, would be all the closing prices of the past 2 weeks, used in calculating the ***Stochastic K.*** of today. And while we're here, the ***Stochastic D.*** would be the average of the 3 ***Stochastic K.s*** prior to each day the ***Stochastic K.*** was calculated for. But, that ***3*** is also a modifiable variable in our data visualization which you will be able to see when hovering over a Stochastic D. node.

The range of days chosen to pick from is ***4 days to 28 days*** in the past. With an iteration randomizing a day picked per indicator, per cycle. 

> If we had more computation power, we would be able to run an iteration to cover every possible combination and permutation. As well as more time, to await results and analyze the data.

For now, we are randomizing, which in itself is more effecient.

**Citations:**
Day Ranges, (Section 6.1): **[NTNU](https://core.ac.uk/download/pdf/52104888.pdf)**

Why Randomize?, (Improved Music Based Harmony Search): **[NITW](https://zenodo.org/record/4650967#.YG5wRGhlC9Y)**

#### Visualization Guide

An iteration is made up of every combination of indicators where the default indicators do not change. At a max of 6 total indicators used per cycle of predictions. So that's 2 indicators picked from the pool available.

**Node Link Diagram:**
Of each of these cycles the best and most accurate prediction of the iteration event, is chosen to be displayed in the node-link diagram. Each of these node link's can account for 1 iteration of every combination exactly once. This results in a total of around ~20 cycles per iteration with our current set of indicators to pick from. ***So if there are 9 node-link diagrams we have run 9 iterations with a total of 180 cycles***.

**Scatter Plot:**
Each individual cycle is plotted, with their prediction outcome and a visual line of the actual price to compare with. Showing a detailed overview of the indicators paired and the days chosen along with it. 

This big picture view, will help us identify the machines observations when drawing disctinctinos through it's vectorization of all the data points. There could be a singular answer or everyone can have their own methodology, relevant to their trading habits. For simplicity, we will look at the weights of the points on either side of the green line and discover a potential momentum change of the security. If left of the green line, we can expect a fall in price, or a ***SELL SIGNAL***, and a ***BUY SIGNAL*** if the points are too the right of the green line.

**Line Plot:**
An interactable line graph of the chosen security, to show us a brief historical summary of factual momentum change of the security and validate predictions previewed on the node-link or scatter plot visualizations.

## Research Notes

****“In this paper we focus on a specific machine learning technique known as Support VectorMachines (SVM). Our goal is to use SVM at timetto predict**** whether a given stock’s price is higher or lower on day t+m. “

https://www.cs.princeton.edu/sites/default/files/uploads/saahil_madge.pdf

---

This papers usage of momentum and volatility in prediction analysis is important.

A Paper from a firm discussing Absolute Return Strategies

https://www.arrowfunds.com/files/DDF/TWST_AbsoluteReturnStrategies.pdf

Range based estimation of stochastic volatility models

https://www.sas.upenn.edu/~fdiebold/papers/paper33/final.pdf

A theory of power-law distributions in financial market fluctuations

https://www.nature.com/articles/nature01624

---

Important paper on the concept of “market whales” where market volatility can be proven to be a causation of large singular stake holders. Simply put, volume and volatility being important factors in deciphering a stock’s distribution of retail and firm based trading activity.
Support Vector Machine for Regression and Applications in Financial Forecasting

https://www.researchgate.net/profile/Theodore-Trafalis/publication/221532842_Support_Vector_Machine_for_Regression_and_Applications_to_Financial_Forecasting/links/573f4f0c08ae298602e8f1e8/Support-Vector-Machine-for-Regression-and-Applications-to-Financial-Forecasting.pdf

Specifically Section 4 has great detail on parameters used for the Radial Basis Function. In this project we are using polynomial regression. But, the data in this, is great in analyzing for hyper parameterization of the SVM .

---

****Paper on Technical Indicator Usage in Market Prediction****

http://www.ajer.org/papers/v5(12)/Z05120207212.pdf

Reports 85% accuracy.

****Great in-depth analysis on Technical Indicator and Price Action decision making.****

https://core.ac.uk/download/pdf/52104888.pdf

Important Sections: 2.2.1, 3, 3.1.1, 3.4
3.1.1 involves the study of Linear Regression
3.4 involvement of stochastics

If time permits, section 4.2 (Decision trees) would be an optional feature in this project, introducing an XGBoost model operation over SVM. Though, XGBoost implementation will be a longer procedure.

---

Improved Music Based Harmony Search (IMBHS)

https://zenodo.org/record/4650967#.YG5wRGhlC9Y

This paper from IJPLA looks at music based harmony search under a job shop scheduling program.
With 3 rules when fine-tuning iterations.

Random selection

Of the 4 MUST HAVE FEATURES 2 additional OPTIONAL FEATURES will be added. Until all OPTIONAL FEATURES have completed their possible combinations. The best combination of the entire run is used. 

---

## Outdated

There used to be a web-app where I back-tested indicator combinations. I still have the front-end source code and am willing to share it. I am unable to host it at the moment, due to server costs. The back-end source code will need to be found, it was done 2 years ago, would not mind spending the time to search if there's enough want. 

> Memory consideration

> We will set a user controlled max iteration count, default is at 9 iterations
(16 runs per iteration) Reaching a max count of 144 training cycles per simulation generation

> Pitch adjustment

> The adjustment for days for each indicator will be randomized with a new one that has yet to be processed.

> Of the 9 iterations each will be visualized
