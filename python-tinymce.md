# This procedure is for "Chrome" on "Ubuntu"

## Step 1: Check whether you have python installed and install it if not

```bash
python3 --version
pip --version

sudo apt update
sudo apt install python3 python3-pip python3-venv
```

I will start with Step 2 since I have Step 1 done already

## Step 2: Close all instances/windows of chrome then run in the terminal to open chrome in debugging mode

```bash
google-chrome --remote-debugging-port=9222
```

## Step 3: Log in into Vclass and navigate to with the answer sheet page

## Step 4: Clone the repo

```bash
git clone https://github.com/mugabiBenjamin/tinymce_typer.git
```

## Step 5: Navigate into the cloned repo

```bash
code tinymce_typer
```

## Step 6: Create an environment and activate it

```bash
python3 -m venv tinymce_typer
source tinymce_typer/bin/activate
```

## Step 7: Install the dependencies

```bash
pip install -r requirements.txt
```

## Step 8: Create an .env file in the root with this command

```bash
    echo "PYTHONPATH=$(pwd)" > .env
```

## Step 9: Create a pyrightconfig.json in the root with this command

```bash
echo '{
  "venvPath": ".",
  "venv": "tinymce_venv",
  "pythonVersion": "3.12",
  "extraPaths": ["./tinymce_venv/lib/python3.12/site-packages"],
  "typeCheckingMode": "off",
  "useLibraryCodeForTypes": true,
  "python.envFile": "${workspaceFolder}/.env"
}' > pyrightconfig.json
```

## Step 10: Run the script, replace [url] with the url of the answersheet

```bash
python scripts/tinymce_typer.py [url] content.txt --use-existing --debugging-port=9222 --batch --batch-size 100 --batch-delay 0.1
```

## Step 11: Don't close the browser window until you have submitted
