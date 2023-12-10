# -*- coding: utf-8 -*-
"""
Created on Mon Jul  4 14:10:07 2022

@author: jlowh
"""

#always start with --init--, this is not a function, define variables in every
# class
# Self allows to inherit globally variable of the class
# variables within init, called it as self.xxxx
# elements in a class locally stay in that Class

class Vehicle:
    def __init__(self, brand, model, type):
        self.brand = brand
        self.model = model
        self.type = type
        self.gas_tank_size = 14 #numbers here are initialized value
        self.fuel_level = 0

    def fuel_up(self):  #Method inherit all global variables in the class
        self.fuel_level = self.gas_tank_size
        print('Gas tank is now full.')

    def drive(self):
        print(f'The {self.model} is now driving.')
        
        
vehicle_object = Vehicle('Honda', 'Ridgeline', 'Truck') # follow the class variables
print("The gas tank has "+str(vehicle_object.fuel_level)+" gallons")

vehicle_object.fuel_up()  #execute the method fuel_up method
print("The gas tank has "+str(vehicle_object.fuel_level)+" gallons")

vehicle_object.drive()