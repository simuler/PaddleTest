export FLAGS_cudnn_deterministic=True
cd ${Project_path}
sed -i 's/RandCropImage/ResizeImage/g'  ppcls/configs/ImageNet/ResNet/ResNet50.yaml
sed -ie '/RandFlipImage/d'  ppcls/configs/ImageNet/ResNet/ResNet50.yaml
sed -ie '/flip_code/d'  ppcls/configs/ImageNet/ResNet/ResNet50.yaml

rm -rf dataset
ln -s ${Data_path} dataset
mkdir log
python -m pip install -r requirements.txt
python -m paddle.distributed.launch tools/train.py -c ppcls/configs/ImageNet/ResNet/ResNet50.yaml -o Global.epochs=2 -o DataLoader.Train.sampler.shuffle=False -o DataLoader.Train.sampler.batch_size=4 -o DataLoader.Eval.sampler.batch_size=4 > log/resnet50_2card.log 2>&1
cat log/resnet50_1card.log | grep Train | grep Avg | grep 'Epoch 2/2' > ../log/resnet50_2card.log
cat log/resnet50_1card.log
