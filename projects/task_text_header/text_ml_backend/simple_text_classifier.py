import pickle
import os
import numpy as np


from google.cloud import storage
import json


from label_studio.ml import LabelStudioMLBase


class SimpleTextClassifier(LabelStudioMLBase):

    gs_bucket_path = "text-header-dataset"
    gs_json_path = "jsons_resize_2"

    def __init__(self, **kwargs):
        # don't forget to initialize base class...
        super(SimpleTextClassifier, self).__init__(**kwargs)

        # then collect all keys from config which will be used to extract data from task and to form prediction
        # Parsed label config contains only one output of <Choices> type
        # assert len(self.parsed_label_config) == 1
        self.from_name, self.info = list(self.parsed_label_config.items())[0]
        print(self.info['type'])
        # assert self.info['type'] == 'RectangleLabels'

        print("================")
        print(self.info)
        print("================")

        # the model has only one textual input
        # assert len(self.info['to_name']) == 1
        # assert len(self.info['inputs']) == 1
        # assert self.info['inputs'][0]['type'] == 'Image'
        self.to_name = self.info['to_name'][0]
        self.value = self.info['inputs'][0]['value']

        self.storage_client = storage.Client()
        self.bucket = self.storage_client.get_bucket(self.gs_bucket_path)


    def reset_model(self):
        self.model = None

    def extract_img_id(self, image_url):
        image_id = image_url.split('?')[0].split('/')[-1].split('.')[0]
        return image_id

    def load_img_json(self, image_id):
        blob = self.bucket.blob(f"{self.gs_json_path}/{image_id}.json")
        data = json.loads(blob.download_as_string(client=None))
        return data

    def parse_text_points(self, img_json):
        # text_points = img_json['annotations']
        # context = img_json['context']

        # image_width = context['image_width']
        # image_height = context['image_height']

        text_boxes = [
            {
                "from_name": "text",
                "to_name": "image",
                "source": "$image",
                "type": "textarea",
                "value": {
                    "text": ["row1 abc \r\n row2 abc \r\n \r\n row3 \r\n \r\n row4"] 
                }
            }
        ]
        return text_boxes
            
    def predict(self, tasks, **kwargs):
        # collect input texts
        # input_texts = []
        results = []
        for task in tasks:
            # image_url = task['data']['image']
            # image_id = self.extract_img_id(image_url)
            # print(image_id)

            # img_json = self.load_img_json(image_id)
            text_boxes = self.parse_text_points(None)
            # input_texts.append(task['data'][self.value])

            results.append({
                'result': text_boxes,
                'score': 0.5
            })
        return results

    def fit(self, completions, workdir=None, **kwargs):
        input_texts = []
        output_labels, output_labels_idx = [], []
        label2idx = {l: i for i, l in enumerate(self.labels)}
        for completion in completions:
            # get input text from task data

            if completion['completions'][0].get('skipped'):
                continue

            input_text = completion['data'][self.value]
            input_texts.append(input_text)

            # get an annotation
            output_label = completion['completions'][0]['result'][0]['value']['choices'][0]
            output_labels.append(output_label)
            output_label_idx = label2idx[output_label]
            output_labels_idx.append(output_label_idx)

        new_labels = set(output_labels)
        if len(new_labels) != len(self.labels):
            self.labels = list(sorted(new_labels))
            print('Label set has been changed:' + str(self.labels))
            label2idx = {l: i for i, l in enumerate(self.labels)}
            output_labels_idx = [label2idx[label] for label in output_labels]

        # train the model
        self.reset_model()
        self.model.fit(input_texts, output_labels_idx)

        # save output resources
        model_file = os.path.join(workdir, 'model.pkl')
        with open(model_file, mode='wb') as fout:
            pickle.dump(self.model, fout)

        train_output = {
            'labels': self.labels,
            'model_file': model_file
        }
        return train_output
