# StoicKit v0.0 - WIP
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
- [Generative Research (Simplified)](#generative-research-(Simplified))
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

## Generative Research (Simplified)

Indicators | [Stoch D.](https://www.investopedia.com/articles/technical/073001.asp) | [Stoch K.](https://www.investopedia.com/articles/technical/073001.asp) | [MacD](https://www.investopedia.com/terms/m/macd.asp) | [EWA](https://www.investopedia.com/terms/e/ema.asp) | [SMA](https://www.investopedia.com/terms/s/sma.asp) | [Vol. Change](https://www.investopedia.com/articles/technical/02/091002.asp) | [RSI](https://www.investopedia.com/terms/r/rsi.asp) 
--- | --- | --- | --- |--- |--- |--- |--- 
***[Volatility](https://www.investopedia.com/terms/v/volatility.asp)*** |  |  |  |  |  |  |  
***[Momentum](https://www.investopedia.com/terms/m/momentum.asp)*** |  |  |  |  |  |  |  |  
***[Change](https://www.investopedia.com/terms/c/change.asp)*** |  |  |  |  |  |  |  |  
***[VWA](https://www.investopedia.com/terms/v/vwap.asp)*** |  |  |  |  |  |  |  |  

An easy way to visualize what is happening is by creating a simple table like above. The left most side, has indicators that we refer to as the ***Defaults***. These indicators will never change, and are defined as stable pivots that will support the distinctions the machine draws from 2 of the indicators we see on the top most columns.

**Citations:** Default Indicators: **[Princeton](https://www.cs.princeton.edu/sites/default/files/uploads/saahil_madge.pdf)**

### Days?

Each indicator requires a common variable. The days to look back into the past in determining the value of the indicator to your target date. So a ***Stochastic K. 14*** of today, would be all the closing prices of the past 2 weeks, used in calculating the ***Stochastic K.*** of today. And while we’re here, the ***Stochastic D.*** would be the average of the 3 ***Stochastic K.s*** prior to each day the ***Stochastic K.*** was calculated for. But, that ***3*** doesn’t always have to be 3. Finding the harmony of all the day variables for each indicator and their ********defaults******** is the core basis behind this forecast simulation.

The range of days chosen to pick from is ***4 days to 28 days*** in the past. With an iteration randomizing a day picked per indicator, per cycle.

**Citations:** Day Ranges, (Section 6.1): **[NTNU](https://ntnuopen.ntnu.no/ntnu-xmlui/handle/11250/252181)**

Important Sections: 2.2.1, 3, 3.1.1, 3.4 3.1.1 involves the study of Linear Regression 3.4 involvement of stochastics

Why Randomize?, (Improved Music Based Harmony Search): **[NITW](https://zenodo.org/record/4650967#.YG5wRGhlC9Y)**

## Extra Reading

---

This papers usage of momentum and volatility in prediction analysis is important.

**A Paper from a firm discussing Absolute Return Strategies**

[Arrow Investments](https://www.arrowfunds.com/files/DDF/TWST_AbsoluteReturnStrategies.pdf)

**Range based estimation of stochastic volatility models**

[UPENN](https://www.sas.upenn.edu/~fdiebold/papers/paper33/final.pdf)

**A theory of power-law distributions in financial market fluctuations**

https://www.nature.com/articles/nature01624

Important paper on the concept of “market whales” where market volatility can be proven to be a causation of large singular stake holders. Simply put, volume and volatility being important factors in deciphering a stock’s distribution of retail and firm based trading activity. Support Vector Machine for Regression and Applications in Financial Forecasting

[University of Oklahoma](https://www.researchgate.net/profile/Theodore-Trafalis/publication/221532842_Support_Vector_Machine_for_Regression_and_Applications_to_Financial_Forecasting/links/573f4f0c08ae298602e8f1e8/Support-Vector-Machine-for-Regression-and-Applications-to-Financial-Forecasting.pdf)

***Paper on Technical Indicator Usage in Market Prediction***

[Reporting 85% accuracy.](http://www.ajer.org/papers/v5(12)/Z05120207212.pdf)

**Improved Music Based Harmony Search (IMBHS)**

This paper from IJPLA looks at music based harmony search under a job shop scheduling program. With 3 rules when fine-tuning iterations.

[IJPLA/Warangal](https://zenodo.org/record/4650967#.YG5wRGhlC9Y)

## Outdated

There used to be a web-app where I back-tested indicator combinations. I still have the front-end source code and am willing to share it. I am unable to host it at the moment, due to server costs. The back-end source code will need to be found, it was done 2 years ago, would not mind spending the time to search if there's enough want. 

> Memory consideration

> We will set a user controlled max iteration count, default is at 9 iterations
(16 runs per iteration) Reaching a max count of 144 training cycles per simulation generation

> Pitch adjustment

> The adjustment for days for each indicator will be randomized with a new one that has yet to be processed.

> Of the 9 iterations each will be visualized
