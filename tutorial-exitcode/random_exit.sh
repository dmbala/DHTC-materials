
EXIT_CODE="$(($$ % 2))"
echo "My exit code is: $EXIT_CODE"

if [ $EXIT_CODE -ne 0 ]; then
  exit $EXIT_CODE
fi
