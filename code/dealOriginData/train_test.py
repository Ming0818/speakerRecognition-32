#!/usr/bin/env python

import os
import logging
import numpy as np
import pandas as pd
import h5py

trainNum = 0
testNum = 0

train_file = 'train.h5'
test_file  = 'test.h5'
featureLength = 39
width = 500
peopleNum = 2
dataTrainAll = np.zeros(featureLength*width+1)
dataTestAll  = np.zeros(featureLength*width+1)

def formHDF5(TRAIN):
	global trainNum,testNum,dataTrainAll,dataTestAll
	df        = pd.read_csv(TRAIN)
	data      = df.values
	np.random.shuffle(data)
	trainset  = len(data) * 4 / 5
	dataTrain = data[:trainset]
	dataTest  = data[trainset:]
	trainNum  = trainNum + trainset;
	testNum   = testNum  + len(data) - trainset;
	dataTrainAll =  np.vstack((dataTrainAll, dataTrain))
	dataTestAll  =  np.vstack((dataTestAll , dataTest ))


def data2h5(data,filein):
	np.random.shuffle(data)
	labels = data[:, 0]
	images = data[:, 1:]
	images = images.reshape((len(images), 1, width, featureLength))
	#images = (images*3.)-150.
	if os.path.exists(filein):
	    os.remove(filein)
	with h5py.File(filein, 'w') as f:
	    f['label'] = labels.astype(np.float32)
	    f['data'] = images.astype(np.int32)

if __name__ == '__main__':
	for i in range(0, peopleNum):
		print(' doing mergeData/'+str(i)+'.csv....')
		formHDF5('mergeData/'+str(i)+'.csv')
	data2h5(dataTrainAll,train_file);
	data2h5(dataTestAll,test_file);
	print('get train pic:%s , get test pic:%s'%(trainNum,testNum))
