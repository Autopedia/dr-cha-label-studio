from google.cloud import storage
import json
import os
from tqdm import tqdm 
from os import listdir
from os.path import isfile, join


if __name__ == '__main__':

    onlyfiles = sorted([f for f in listdir('tasks_json') if isfile(join('tasks_json', f))])
    print(len(onlyfiles))
    print(onlyfiles[0])

    item_id_list = []
    for filename in onlyfiles:
        item_id = int(filename.split('_')[1].split('_')[0])
        item_id_list.append(item_id)
        print(item_id)
    print(max(item_id_list))
    print(min(item_id_list))
    print(len(set(item_id_list)))

    # for filename in tqdm(onlyfiles):
    #     with open(f'jsons_resize_2/{filename}', 'r') as j:
    #         context = json.load(j)['context']
            
    #         resize_image_id = filename.split('.')[0]

    #         file_id = context['file_id']
    #         origin_file_id = file_id.split('_')[0]
    #         item_name = context['item_name']

    #         task = {
    #             "data": {
    #                 "image": f"https://storage.cloud.google.com/text-header-dataset/images_resize_2/{resize_image_id}.jpg?authuser=3",
    #                 "full_url": f"<a href=\"https://storage.cloud.google.com/text-header-dataset/images2/{origin_file_id}?authuser=3\">원본 이미지 링크</a>",
    #                 "item_name": item_name
    #             }
    #         }
    #         # print(task)

    #         with open(f'tasks_2/task_{filename}', 'w') as file:
    #             json.dump(task, file)
            