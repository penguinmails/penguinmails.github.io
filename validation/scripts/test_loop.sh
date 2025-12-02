#!/bin/bash

# Simple test script to verify loops work in GitHub Actions
echo "Testing basic loop functionality from script:"
for i in 1 2 3 4 5; do
  echo "::error::Test error number $i from script"
done
echo "Script loop test complete"
