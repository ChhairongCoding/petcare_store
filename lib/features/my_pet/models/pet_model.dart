import 'package:flutter/material.dart';

class Pet {
  final int id;
  final String name;
  final String breed;
  final String age;
  final String weight;
  final String gender;
  final String image;
  final Color color;

  // Health details
  final String vaccinationStatus;
  final String lastCheckup;
  final String nextCheckup;
  final List<String> allergies;
  final String medicalConditions;

  // Feeding details
  final String foodType;
  final String feedingSchedule;
  final String dailyPortion;
  final String specialDiet;

  // Distance (could be distance to vet, park, etc.)
  final double distanceToVet;
  final String nearestVetName;
  final String vetAddress;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    required this.gender,
    required this.image,
    required this.color,
    required this.vaccinationStatus,
    required this.lastCheckup,
    required this.nextCheckup,
    required this.allergies,
    required this.medicalConditions,
    required this.foodType,
    required this.feedingSchedule,
    required this.dailyPortion,
    required this.specialDiet,
    required this.distanceToVet,
    required this.nearestVetName,
    required this.vetAddress,
  });

  // Factory constructor for creating Pet from Map (for mock data)
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      breed: map['breed'],
      age: map['age'],
      weight: map['weight'],
      gender: map['gender'],
      image: map['image'],
      color: map['color'],
      vaccinationStatus: map['vaccinationStatus'] ?? 'Up to date',
      lastCheckup: map['lastCheckup'] ?? '2024-01-15',
      nextCheckup: map['nextCheckup'] ?? '2024-07-15',
      allergies: List<String>.from(map['allergies'] ?? []),
      medicalConditions: map['medicalConditions'] ?? 'None',
      foodType: map['foodType'] ?? 'Dry kibble',
      feedingSchedule: map['feedingSchedule'] ?? '2 times per day',
      dailyPortion: map['dailyPortion'] ?? '200g',
      specialDiet: map['specialDiet'] ?? 'None',
      distanceToVet: map['distanceToVet'] ?? 2.5,
      nearestVetName: map['nearestVetName'] ?? 'City Pet Clinic',
      vetAddress: map['vetAddress'] ?? '123 Main St, City',
    );
  }
}
