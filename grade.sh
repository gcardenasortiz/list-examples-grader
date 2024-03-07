CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission 2> git-output.txt
echo 'Finished cloning'

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point
if [ ! -f "student-submission/ListExamples.java" ]; then
    echo "Incorrect file submitted. Please submit the correct file."
    exit 1
fi

cp -r student-submission/ grading-area/

cp TestListExamples.java grading-area/

cd grading-area 
if javac -cp $CPATH *.java; then
    echo 'Compilation successful.'
else
    echo 'Compilation failed. Please check your code and try again.'
    exit 2
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test_results.txt

# Add any post-processing steps here
if grep 'OK' test_results.txt; then
    echo "Grade = 100%"
else 
    lastline=$(tail -n 2 test_results.txt | head -n 1)
    tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
    failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
    successes="Grade = $(((tests - failures) / tests))%"
    echo $successes
fi



