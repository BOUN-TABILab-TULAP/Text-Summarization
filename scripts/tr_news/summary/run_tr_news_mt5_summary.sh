#!/bin/bash
#SBATCH -p akya-cuda
#SBATCH -A bbaykara
#SBATCH -J mt5_tr_news
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 40
#SBATCH --gres=gpu:4
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=ALL

module load centos7.3/lib/cuda/10.1

echo "SLURM_NODELIST $SLURM_NODELIST"
echo "NUMBER OF CORES $SLURM_NTASKS"
echo "CUDA DEVICES $CUDA_VISIBLE_DEVICES"

RUN_NAME=tr_news_mt5_summary
OUTPUTS_DIR=/truba/home/bbaykara/code/enc_dec_sum/outputs/$RUN_NAME

/truba/home/bbaykara/code/enc_dec_sum/venv/bin/python -m torch.distributed.launch --nproc_per_node=4 /truba/home/bbaykara/code/enc_dec_sum/run_summarization.py \
--model_name_or_path google/mt5-base \
--do_train \
--do_eval \
--early_stopping_patience 2 \
--do_predict \
--load_best_model_at_end \
--num_beams 4 \
--max_source_length 768 \
--max_target_length 128 \
--save_strategy epoch \
--evaluation_strategy epoch \
--train_file /truba/home/bbaykara/code/enc_dec_sum/data/tr_news_raw/train.csv \
--validation_file /truba/home/bbaykara/code/enc_dec_sum/data/tr_news_raw/validation.csv \
--test_file /truba/home/bbaykara/code/enc_dec_sum/data/tr_news_raw/test.csv \
--source_prefix "summarize: " \
--output_dir $OUTPUTS_DIR \
--logging_dir $OUTPUTS_DIR/logs \
--overwrite_output_dir \
--predict_with_generate \
--text_column content \
--summary_column abstract \
--do_tr_lowercase \
--preprocessing_num_workers 20 \
--dataloader_num_workers 2 \
--gradient_accumulation_steps 4 \
--per_gpu_train_batch_size 2 \
--per_gpu_eval_batch_size 2 \
--num_train_epochs 10 \
--logging_steps 500 \
--learning_rate 1e-3 \
--warmup_steps 1000 \
--sharded_ddp simple \
--adafactor
