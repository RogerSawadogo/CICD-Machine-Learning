install:
	pip install --upgrade pip
	pip install -r requirements.txt

format:
	black .

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
	echo "" >> report.md
	echo "## Confusion Matrix Plot" >> report.md
	echo "![Confusion Matrix](./Results/model_results.png)" >> report.md
	cml comment create report.md

hf-login:
	git pull origin update
	git switch update
	pip install -U "huggingface_hub[cli]"
	huggingface-cli login --token ${HF} --add-to-git-credential

push-hub:
	huggingface-cli upload Rimro/Drug-Classification ./App --repo-type=space --commit-message="Sync App files" --create-pr
	huggingface-cli upload Rimro/Drug-Classification ./Model /Model --repo-type=space --commit-message="Sync Model" --create-pr
	huggingface-cli upload Rimro/Drug-Classification ./Results /Metrics --repo-type=space --commit-message="Sync Metrics" --create-pr


deploy: hf-login push-hub
