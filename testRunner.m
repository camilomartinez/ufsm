% Initialization
clear;
clc;
% Run test suite
results = runtests('test','Recursively',true);
table(results)