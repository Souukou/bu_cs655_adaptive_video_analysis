# Analyzing Transmission Policies for Adaptive Video
BU CS655 Computer Network - GENI project

# Steps to Reproduce the Experiment

## Prepare the Environment

### Reserve GENI resource

Log in to the [GENI Portal](https://portal.geni.net/secure/createslice.php), then [create a new slice](https://portal.geni.net/secure/createslice.php) with any name.

```
https://portal.geni.net/secure/createslice.php
```

Add the resource use rspec file in `config/adaptive-video-request-rspec.xml`. You can choose any GENI site but I found Stanford InstaGENI is more reliable than some others.

```
https://github.com/Souukou/bu_cs655_adaptive_video_analysis/raw/main/geni_config/adaptive-video-request-rspec.xml
```

Make sure you have set up an SSH agent and you should be login to three servers without password. Then we will install some necessary software and download some files into each server.

### Prepare the nodes

In the server node, run `scripts/setup/server.sh` to set up using the following command. By default in GENI lab, users have sudo access without prompting password.

```
bash <(curl -L https://github.com/Souukou/bu_cs655_adaptive_video_analysis/raw/main/setup/server.sh)
```

In the router node, run `scripts/setup/router.sh` to set up using the following command.

```
bash <(curl -L https://github.com/Souukou/bu_cs655_adaptive_video_analysis/blob/raw/setup/router.sh)
```


In the client node, run `scripts/setup/client.sh` to set up using the following command.

```
bash <(curl -L https://github.com/Souukou/bu_cs655_adaptive_video_analysis/raw/main/setup/client.sh)
```

## Experiment 1: Constant Bitrate

In your LOCAL computer, run the following command. It takes about 8 minutes. If you use Windows, please use PowerShell (Use Win+X, then click PowerShell/Windows Terminal, depending  on your windows version). Make sure you have already set up an SSH agent so that you can access all nodes without password.

```
ssh USERNAME@ROUTER_ADDR_ -p ROUTER_PORT 'nohup bash rate-set.sh 1000Kbit >/dev/null 2>&1 &'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 120 basic'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 120 netflix'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 120 sara'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'rm constant_bitrate.zip; zip constant_bitrate.zip -r basic.csv netflix.csv sara.csv && rm basic.csv netflix.csv sara.csv'

sftp -P CLIENT_PORT USERNAME@CLIENT_ADDR:~/constant_bitrate.zip .
```

For example

```
ssh yuhangs@pc5.instageni.stanford.edu -p 26211 'nohup bash rate-set.sh 1000Kbit >/dev/null 2>&1 &'

ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 120 basic'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 120 netflix'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 120 sara'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'rm constant_bitrate.zip; zip constant_bitrate.zip -r basic.csv netflix.csv sara.csv && rm basic.csv netflix.csv sara.csv'

sftp -P 26210 yuhangs@pc5.instageni.stanford.edu:constant_bitrate.zip .

```

After that, you will get `constant_bitrate.zip` contains three trace files. Put them into jupyter nodebook `jupyter-notebook/exp_1_constant_bitrate.ipynb`, you can reproduce the graph we shown in the report. You can easily access Google Colab version using the following link.

```
https://colab.research.google.com/github/souukou/bu_cs655_adaptive_video_analysis/blob/main/jupyter-notebook/exp_1_constant_bitrate.ipynb
```

## Experiemnt 2: Constant Bitrate with Interrupt

In your LOCAL computer, run the following command. It takes about 10 minutes.

```
ssh USERNAME@ROUTER_ADDR_ -p ROUTER_PORT 'nohup timeout 150 bash rate-interrupt.sh >/dev/null 2>&1 &'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 150 basic'

ssh USERNAME@ROUTER_ADDR_ -p ROUTER_PORT 'nohup timeout 150 bash rate-interrupt.sh >/dev/null 2>&1 &'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 150 netflix'

ssh USERNAME@ROUTER_ADDR_ -p ROUTER_PORT 'nohup timeout 150 bash rate-interrupt.sh >/dev/null 2>&1 &'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 150 sara'

ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'rm constant_bitrate_with_interrupt.zip; zip constant_bitrate_with_interrupt.zip -r basic.csv netflix.csv sara.csv && rm basic.csv netflix.csv sara.csv'

sftp -P CLIENT_PORT USERNAME@CLIENT_ADDR:~/constant_bitrate_with_interrupt.zip .
```

For example

```
ssh yuhangs@pc5.instageni.stanford.edu -p 26211 'nohup timeout 150 bash rate-interrupt.sh >/dev/null 2>&1 &'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 150 basic'

ssh yuhangs@pc5.instageni.stanford.edu -p 26211 'nohup timeout 150 bash rate-interrupt.sh >/dev/null 2>&1 &'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 150 netflix'

ssh yuhangs@pc5.instageni.stanford.edu -p 26211 'nohup timeout 150 bash rate-interrupt.sh >/dev/null 2>&1 &'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 150 sara'

ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'rm constant_bitrate_with_interrupt.zip; zip constant_bitrate_with_interrupt.zip -r basic.csv netflix.csv sara.csv && rm basic.csv netflix.csv sara.csv'

sftp -P 26210 yuhangs@pc5.instageni.stanford.edu:constant_bitrate_with_interrupt.zip .

```

After that, you will get `constant_bitrate_with_interrupt.zip` contains three trace files. Put them into jupyter nodebook `jupyter-notebook/exp_2_constant_bitrate_with_interrupt.ipynb`, you can reproduce the graph we shown in the report. You can easily access Google Colab version using the following link.

```
https://colab.research.google.com/github/souukou/bu_cs655_adaptive_video_analysis/blob/main/jupyter-notebook/exp_2_constant_bitrate_with_interrupt.ipynb
```

## Experiemnt 3: Mobile User with Stable Network (bus_62)

In your LOCAL computer, run the following command. It takes about 30 minutes.

```
ssh USERNAME@ROUTER_ADDR_ -p ROUTER_PORT 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Bus_B62/bus62.csv 0.5 >/dev/null 2>&1 &'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 600 basic'

ssh USERNAME@ROUTER_ADDR_ -p ROUTER_PORT 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Bus_B62/bus62.csv 0.5 >/dev/null 2>&1 &'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 600 netflix'

ssh USERNAME@ROUTER_ADDR_ -p ROUTER_PORT 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Bus_B62/bus62.csv 0.5 >/dev/null 2>&1 &'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 600 sara'

ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'rm constant_bitrate_with_interrupt.zip; zip constant_bitrate_with_interrupt.zip -r basic.csv netflix.csv sara.csv && rm basic.csv netflix.csv sara.csv'

sftp -P CLIENT_PORT USERNAME@CLIENT_ADDR:~/constant_bitrate_with_interrupt.zip .
```

For example

```
ssh yuhangs@pc5.instageni.stanford.edu -p 26211 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Bus_B62/bus62.csv 0.5 >/dev/null 2>&1 &'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 600 basic'

ssh yuhangs@pc5.instageni.stanford.edu -p 26211 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Bus_B62/bus62.csv 0.5 >/dev/null 2>&1 &'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 600 netflix'

ssh yuhangs@pc5.instageni.stanford.edu -p 26211 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Bus_B62/bus62.csv 0.5 >/dev/null 2>&1 &'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 600 sara'

ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'rm mobile_stable.zip; zip mobile_stable.zip -r basic.csv netflix.csv sara.csv && rm basic.csv netflix.csv sara.csv'

sftp -P 26210 yuhangs@pc5.instageni.stanford.edu:mobile_stable.zip .

```

After that, you will get `mobile_stable.zip` contains three trace files. Put them into jupyter nodebook `jupyter-notebook/exp_3_mobile_stable.ipynb`, you can reproduce the graph we shown in the report. You can easily access Google Colab version using the following link.

```
https://colab.research.google.com/github/souukou/bu_cs655_adaptive_video_analysis/blob/main/jupyter-notebook/exp_3_mobile_stable.ipynb
```

## Experiemnt 4: Mobile User with Unstable Network (car_2)

In your LOCAL computer, run the following command. It takes about 30 minutes.

```
ssh USERNAME@ROUTER_ADDR_ -p ROUTER_PORT 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Car/Car_2.csv 0.2 >/dev/null 2>&1 &'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 600 basic'

ssh USERNAME@ROUTER_ADDR_ -p ROUTER_PORT 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Car/Car_2.csv 0.2 >/dev/null 2>&1 &'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 600 netflix'

ssh USERNAME@ROUTER_ADDR_ -p ROUTER_PORT 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Car/Car_2.csv 0.2 >/dev/null 2>&1 &'
ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'bash ~/exp_client.sh 600 sara'

ssh USERNAME@CLIENT_ADDR -p CLIENT_PORT 'rm constant_bitrate_with_interrupt.zip; zip constant_bitrate_with_interrupt.zip -r basic.csv netflix.csv sara.csv && rm basic.csv netflix.csv sara.csv'

sftp -P CLIENT_PORT USERNAME@CLIENT_ADDR:~/constant_bitrate_with_interrupt.zip .
```

For example

```
ssh yuhangs@pc5.instageni.stanford.edu -p 26211 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Car/Car_2.csv 0.2 >/dev/null 2>&1 &'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 600 basic'

ssh yuhangs@pc5.instageni.stanford.edu -p 26211 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Car/Car_2.csv 0.2 >/dev/null 2>&1 &'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 600 netflix'

ssh yuhangs@pc5.instageni.stanford.edu -p 26211 'nohup timeout 600 bash rate-vary.sh ~/NYU-METS-Dataset/Car/Car_2.csv 0.2 >/dev/null 2>&1 &'
ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'bash ~/exp_client.sh 600 sara'

ssh yuhangs@pc5.instageni.stanford.edu -p 26210 'rm mobile_unstable.zip; zip mobile_unstable.zip -r basic.csv netflix.csv sara.csv && rm basic.csv netflix.csv sara.csv'

sftp -P 26210 yuhangs@pc5.instageni.stanford.edu:mobile_unstable.zip .

```

After that, you will get `mobile_unstable.zip` contains three trace files. Put them into jupyter nodebook `jupyter-notebook/exp_4_mobile_unstable.ipynb`, you can reproduce the graph we shown in the report. You can easily access Google Colab version using the following link.

```
https://colab.research.google.com/github/souukou/bu_cs655_adaptive_video_analysis/blob/main/jupyter-notebook/exp_4_mobile_unstable.ipynb
```

# Experiment Report

Can be found in `Analyzing Transmission Policies for Adaptive Video.pdf`
