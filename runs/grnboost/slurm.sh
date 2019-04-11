#!/bin/bash
#SBATCH --job-name=mrnet
#SBATCH --output=log%J.out
#SBATCH --error=err%J.err
#SBATCH --ntasks=1
#SBATCH --time=72:00:00

date
pwd

module load singularity-3.0

export JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/
# ./build.sh
# singularity pull docker://tanyard/im:grnboost
# singularity run im_grnboost.sif mvn -version

singularity run im_grnboost.sif /usr/local/bin/spark/bin/spark-submit \
     --class org.aertslab.grnboost.GRNBoost \
     --master local[*] \
     --deploy-mode client \
     --jars /m2/repo/ml/dmlc/xgboost4j/0.83-SNAPSHOT/xgboost4j-0.83-SNAPSHOT.jar \
      /work/GRNBoost/target/scala-2.11/GRNBoost.jar \
     infer \
     -i ${infile} \
     -tf ${genes} \
     -o ./grnboost.out \
     -p eta=0.01 \
     -p max_depth=3 \
     -p colsample_bytree=0.1 \
     --truncate 100000

echo
date