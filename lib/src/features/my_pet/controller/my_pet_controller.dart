import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:petcare_store/src/features/my_pet/models/pet_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import '../models/my_pet_entity.dart';

class MyPetController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  final RxList<PetModel> pets = <PetModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxnString errorMessage = RxnString();

  late final String _bucketName;

  MyPetController() {
    _bucketName = _resolveBucketName();
  }

  @override
  void onInit() {
    super.onInit();
    fetchPets();
  }

  Future<void> fetchPets() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      errorMessage.value = 'Please login to manage your pets.';
      pets.clear();
      return;
    }

    try {
      isLoading(true);
      errorMessage.value = null;

      final response = await _client
          .from('mypet')
          .select()
          .eq('owner', user.id)
          .order('created_at', ascending: false);

      final fetched = response.map((item) => PetModel.fromMap(item)).toList();

      pets.assignAll(fetched);
      isLoading(false);
    } on PostgrestException catch (e, stack) {
      developer.log(
        'PostgREST error when fetching pets',
        error: e,
        stackTrace: stack,
      );
      errorMessage.value = e.message;
    } on SocketException catch (e, stack) {
      developer.log(
        'Network error when fetching pets',
        error: e,
        stackTrace: stack,
      );
      errorMessage.value = 'No internet connection.';
    } catch (e, stack) {
      developer.log(
        'Unexpected error when fetching pets',
        error: e,
        stackTrace: stack,
      );
      errorMessage.value = 'Unable to load pets right now.';
    } finally {
      isLoading(false);
    }
  }

  Future<void> addPet({
    required Uint8List avatar,
    required String name,
    required String type,
    required String breed,
    required int age,
    required String gender,
    String? lat,
    String? long,
  }) async {
    isSubmitting(true);
    try {
      // Ensure session
      final session = _client.auth.currentSession;
      developer.log('current session: ${session?.accessToken != null}');
      if (session == null) {
        errorMessage.value = 'Please sign in first.';
        return;
      }

      final user = session.user;
      developer.log('user id: ${user.id}');
      developer.log('bucket: $_bucketName');

      final avatarUrl = await _uploadAvatarFromBytes(avatar, ownerId: user.id);
      final payload = {
        'owner': user.id,
        'name': name,
        'type': type,
        'breed': breed,
        'age': age,
        'gender': gender,
        'avatar': avatarUrl,
        'lat': lat,
        'long': long,
      };

      final row = await _client.from('mypet').insert(payload).select().single();
      pets.add(PetModel.fromMap(row));
    } on StorageException catch (e, st) {
      developer.log('Storage error', error: e, stackTrace: st);
      errorMessage.value = e.message; // 403 = policy / 404 = wrong bucket
    } on PostgrestException catch (e, st) {
      developer.log('PostgREST error', error: e, stackTrace: st);
      errorMessage.value = e.message;
    } catch (e, st) {
      developer.log('Unexpected addPet error', error: e, stackTrace: st);
      errorMessage.value = 'Unexpected error';
    } finally {
      isSubmitting(false);
    }
  }

  Future<void> deletePet(String id) async {
    try {
      isLoading(true);
      await _client.from('mypet').delete().eq('id', id);
      // pets.removeWhere((existing) => existing.i == pet.id);
      errorMessage.value = "Pet deleted successfully";
      fetchPets();
      isLoading(false);
    } on PostgrestException catch (e, stack) {
      developer.log(
        'PostgREST error when deleting pet',
        error: e,
        stackTrace: stack,
      );
      Get.snackbar('Unable to delete pet', e.message);
    } on SocketException catch (e, stack) {
      developer.log(
        'Network error when deleting pet',
        error: e,
        stackTrace: stack,
      );
      Get.snackbar('Network error', 'Check your connection and try again.');
    } catch (e, stack) {
      developer.log(
        'Unexpected error when deleting pet',
        error: e,
        stackTrace: stack,
      );
      Get.snackbar('Unable to delete pet', 'Please try again later.');
    }
  }

  // Future<String?> _uploadAvatarFromFile(
  //   File file, {
  //   required String ownerId,
  // }) async {
  //   final extension = _fileExtension(file.path);
  //   final objectPath = _buildStoragePath(ownerId, extension);
  //   await _client.storage
  //       .from(_bucketName)
  //       .upload(
  //         objectPath,
  //         file,
  //         fileOptions: FileOptions(
  //           cacheControl: '3600',
  //           upsert: false,
  //           contentType: _contentTypeFromExtension(extension),
  //         ),
  //       );
  //   return _client.storage.from(_bucketName).getPublicUrl(objectPath);
  // }

  Future<String?> uploadAvatarFromBytes(
    Uint8List data, {
    String? extensionHint,
  }) async {
    final session = _client.auth.currentSession;
    if (session == null) {
      errorMessage.value = 'Please sign in first.';
      return null;
    }
    final user = session.user;
    return _uploadAvatarFromBytes(data, ownerId: user.id, extensionHint: extensionHint);
  }

  Future<String?> _uploadAvatarFromBytes(
    Uint8List data, {
    required String ownerId,
    String? extensionHint,
  }) async {
    final extension = extensionHint ?? '.jpg';
    final objectPath = _buildStoragePath(ownerId, extension);
    await _client.storage
        .from(_bucketName)
        .uploadBinary(
          objectPath,
          data,
          fileOptions: FileOptions(
            cacheControl: '3600',
            upsert: false,
            contentType: _contentTypeFromExtension(extension),
          ),
        );

    return _client.storage.from(_bucketName).getPublicUrl(objectPath);
  }

  String _buildStoragePath(String ownerId, String extension) {
    final sanitizedExt = extension.startsWith('.')
        ? extension
        : '.${extension.trim()}';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'pets/$ownerId/$timestamp$sanitizedExt';
  }

  String _fileExtension(String path) {
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex == -1) return '.jpg';
    return path.substring(dotIndex).toLowerCase();
  }

  String _contentTypeFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.bmp':
        return 'image/bmp';
      default:
        return 'image/jpeg';
    }
  }

  String _resolveBucketName() {
    final explicit = dotenv.env['petBucketName']?.trim();
    if (explicit != null && explicit.isNotEmpty) {
      return explicit;
    }

    final fallbackUrl =
        dotenv.env['petBucketUrl']?.trim() ?? dotenv.env['bucketUrl']?.trim();
    if (fallbackUrl == null || fallbackUrl.isEmpty) {
      return 'product_image';
    }

    final uri = Uri.tryParse(fallbackUrl);
    if (uri == null) return 'product_image';

    final segments = uri.pathSegments
        .where((segment) => segment.isNotEmpty)
        .toList();
    final publicIndex = segments.indexOf('public');

    if (publicIndex != -1 && publicIndex + 1 < segments.length) {
      return segments[publicIndex + 1];
    }

    return segments.isNotEmpty ? segments.last : 'product_image';
  }

  Future<void> updatePet(PetModel pet) async {
    try {
      isLoading(true);
      await _client.from('mypet').update(pet.toMap()).eq('id', pet.id);
      // Update the local list
      final index = pets.indexWhere((p) => p.id == pet.id);
      if (index != -1) {
        pets[index] = pet;
      }
      isLoading(false);
    } on PostgrestException catch (e, stack) {
      developer.log(
        'PostgREST error when updating pet',
        error: e,
        stackTrace: stack,
      );
      Get.snackbar('Unable to update pet', e.message);
    } on SocketException catch (e, stack) {
      developer.log(
        'Network error when updating pet',
        error: e,
        stackTrace: stack,
      );
      Get.snackbar('Network error', 'Check your connection and try again.');
    } catch (e, stack) {
      developer.log('Unexpected error when updating pet', error: e, stackTrace: stack);
      Get.snackbar('Unable to update pet', 'Please try again later.');
    }
  }
}
