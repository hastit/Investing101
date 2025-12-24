#!/bin/bash
cd /Users/hasti/Desktop/InvestmentApp/InvestmentApp/InvestmentApp/Views
# Remove line 389 if it's a closing brace
sed -i '' '389d' LearnView.swift 2>/dev/null || true
