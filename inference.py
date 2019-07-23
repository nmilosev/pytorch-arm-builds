import torch
import sys
from torchvision import models
from PIL import Image
from pprint import pprint
import time

# net = models.squeezenet1_0(pretrained=True)
net = models.shufflenet_v2_x1_0(pretrained=True)
# net = models.mobilenet_v2(pretrained=True)

net.eval()

with open('imagenet_classes.txt') as f:
  labels = [line.strip() for line in f.readlines()]

from torchvision import transforms
transform = transforms.Compose([            #[1]
 transforms.Resize(256),                    #[2]
 transforms.CenterCrop(224),                #[3]
 transforms.ToTensor(),                     #[4]
 transforms.Normalize(                      #[5]
 mean=[0.485, 0.456, 0.406],                #[6]
 std=[0.229, 0.224, 0.225]                  #[7]
 )])

def infer(path):
    img = Image.open(path)
    img_t = transform(img)
    batch_t = torch.unsqueeze(img_t, 0)
    out = net(batch_t)
    percentage = torch.nn.functional.softmax(out, dim=1)[0] * 100
    _, indices = torch.sort(out, descending=True)
    pprint([(labels[idx], percentage[idx].item()) for idx in indices[0][:5]])

if __name__ == '__main__':
    for _ in range(10):
        start = time.time()  
        infer(sys.argv[1])
        end = time.time()
        print(end - start)
