# coreml-convertation-bug
We demonstrate a discrepancy in coreml model predictions in iOS11 and iOS12.

## Abstract

Coreml model gives incorrect predictions on iOS12 (while working correctly in iOS11).

## Description

We have an identity model that recieves 416x416x3 picture as input and returns the same picture.
<br>
This square model works __correctly__ in both iOS11 and iOS12.

We create a model with 740x416x3 input and initialize it with the square model weights.
<br>
This rectangle model returns __incorrect__ output in iOS12 (but works correctly in iOS11).

We've tried tuning image scale and coreml convertation scale but it didn't help.

We use 
* Python2.7
* coremltools==2.0 
* keras==2.1.3

## Links

[ipython demo](https://github.com/varvara-krasavina/coreml-convertation-bug/blob/master/ipynb-demo/demo.ipynb)
<br>
[swift playground](https://github.com/varvara-krasavina/coreml-convertation-bug/tree/master/swift-playground-demo/identity_playground.playground)
