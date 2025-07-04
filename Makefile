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

update-branch:
	git config --global user.name $(USER_NAME)
	git config --global user.email $(USER_EMAIL)
	git commit -am "Update with new results"
	git push --force origin HEAD:update


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
