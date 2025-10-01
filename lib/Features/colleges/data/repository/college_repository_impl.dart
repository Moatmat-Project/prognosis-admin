import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/error/failures.dart';
import 'package:moatmat_admin/Features/colleges/data/datasources/college_remote_data_source.dart';
import 'package:moatmat_admin/Features/colleges/data/models/college_m.dart';
import 'package:moatmat_admin/Features/colleges/domain/entities/college.dart';
import 'package:moatmat_admin/Features/colleges/domain/repository/college_repository.dart';

class CollegeRepositoryImpl implements CollegeRepository {
  final CollegeRemoteDataSource remoteDataSource;

  CollegeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addCollege(College college) async {
    try {
      await remoteDataSource.addCollege(CollegeModel(
        id: college.id,
        name: college.name,
        imageUrl: college.imageUrl,
        schoolId: college.schoolId,
      ));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCollege(int id) async {
    try {
      await remoteDataSource.deleteCollege(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> editCollege(College college) async {
    try {
      await remoteDataSource.updateCollege(CollegeModel(
        id: college.id,
        name: college.name,
        imageUrl: college.imageUrl,
        schoolId: college.schoolId,
      ));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<College>>> getAllColleges() async {
    try {
      final colleges = await remoteDataSource.getAllColleges();
      return Right(colleges);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<College>>> getCollegesBySchoolId(
      int schoolId) async {
    try {
      final colleges = await remoteDataSource.getCollegesBySchoolId(schoolId);
      return Right(colleges);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}
