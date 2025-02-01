# bash ./scripts/b2n_test.sh caltech101
TRAINER=HPT_PLUS
CFG=b2n
SHOTS=16
LOADEP=10
GPU=0

OUTPUT_DIR=./results
DATA=./data

DATASET=$1
ALPHA=$2
N_SET=$3
EP=$4

for SEED in 1 2 3
do

    COMMON_DIR=${DATASET}/${TRAINER}/${CFG}_alpha_${ALPHA}_shots_${SHOTS}_n_${N_SET}_ep_${EP}/seed${SEED}
    DIRTRAIN=${OUTPUT_DIR}/output_plus/B2N/train_base/${COMMON_DIR}
    DIRTEST=${OUTPUT_DIR}/output_plus/B2N/test_new/${COMMON_DIR}

    if [ -d "$DIRTEST" ]; then
        echo "Oops! The results exist at ${DIRTEST} (so skip this job)"
    else
        CUDA_VISIBLE_DEVICES=${GPU} python train.py \
        --root ${DATA} \
        --seed ${SEED} \
        --trainer ${TRAINER} \
        --dataset-config-file configs/datasets/b2n/${DATASET}.yaml \
        --config-file configs/trainers/${TRAINER}/${CFG}.yaml \
        --output-dir ${DIRTEST} \
        --model-dir ${DIRTRAIN} \
        --load-epoch ${LOADEP} \
        --eval-only \
        DATASET.NUM_SHOTS ${SHOTS} \
        DATASET.SUBSAMPLE_CLASSES new \
        TRAINER.HPT_PLUS.ALPHA ${ALPHA} \
        TRAINER.HPT_PLUS.N_SET ${N_SET}
    fi

done
