import json
import os
from tqdm import tqdm 
from os import listdir
from os.path import isfile, join
from collections import Counter

from google.cloud import storage


if __name__ == '__main__':

    onlyfiles = [f for f in listdir('outputs') if isfile(join('outputs', f))]
    print(len(onlyfiles))
    print(onlyfiles[0])

    list_worker = []
    for filename in tqdm(onlyfiles):
        if '.' not in filename:
            with open(f'outputs/{filename}', 'r') as j:
                for completion in json.load(j)['completions']:
                    worker = completion.get('worker', None)
                    if worker: 
                        print(worker)
                        list_worker.append(worker)

    counter = Counter(list_worker)
    print(counter)
            
            # resize_image_id = filename.split('.')[0]

            # file_id = context['file_id']
            # origin_file_id = file_id.split('_')[0]
            # item_name = context['item_name']

            # task = {
            #     "data": {
            #         "image": f"https://storage.cloud.google.com/text-header-dataset/images_resize_2/{resize_image_id}.jpg?authuser=3",
            #         "full_url": f"<a href=\"https://storage.cloud.google.com/text-header-dataset/images2/{origin_file_id}?authuser=3\">원본 이미지 링크</a>",
            #         "item_name": item_name
            #     }
            # }
            # # print(task)

            # with open(f'tasks_2/task_{filename}', 'w') as file:
            #     json.dump(task, file)
            