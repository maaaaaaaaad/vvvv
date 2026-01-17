import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final domains = ['auth', 'owner', 'beautishop', 'category', 'treatment', 'review'];
  final projectRoot = _findProjectRoot();
  final libPath = '$projectRoot/lib';
  final testPath = '$projectRoot/test';

  group('Test Coverage Tests', () {
    group('UseCase Test Coverage', () {
      for (final domain in domains) {
        test('All $domain usecases should have test files', () {
          final usecasesPath = '$libPath/features/$domain/domain/usecases';
          final testUsecasesPath = '$testPath/features/$domain/domain/usecases';

          final usecaseFiles = _getDartFiles(usecasesPath);
          final missingTests = <String>[];

          for (final usecaseFile in usecaseFiles) {
            final fileName = _getFileName(usecaseFile);
            final testFileName =
                '${fileName.replaceAll('.dart', '')}_test.dart';
            final testFilePath = '$testUsecasesPath/$testFileName';

            if (!File(testFilePath).existsSync()) {
              missingTests.add(fileName);
            }
          }

          expect(
            missingTests,
            isEmpty,
            reason:
                'Missing test files for $domain usecases:\n'
                '${missingTests.map((f) => '  - $f').join('\n')}\n'
                'Expected test files at: $testUsecasesPath/',
          );
        });
      }
    });

    group('Repository Test Coverage', () {
      for (final domain in domains) {
        test(
          'All $domain repository implementations should have test files',
          () {
            final repositoriesPath =
                '$libPath/features/$domain/data/repositories';
            final testRepositoriesPath =
                '$testPath/features/$domain/data/repositories';

            final repositoryFiles = _getDartFiles(repositoriesPath);
            final missingTests = <String>[];

            for (final repositoryFile in repositoryFiles) {
              final fileName = _getFileName(repositoryFile);
              final testFileName =
                  '${fileName.replaceAll('.dart', '')}_test.dart';
              final testFilePath = '$testRepositoriesPath/$testFileName';

              if (!File(testFilePath).existsSync()) {
                missingTests.add(fileName);
              }
            }

            expect(
              missingTests,
              isEmpty,
              reason:
                  'Missing test files for $domain repositories:\n'
                  '${missingTests.map((f) => '  - $f').join('\n')}\n'
                  'Expected test files at: $testRepositoriesPath/',
            );
          },
        );
      }
    });

    group('Entity Test Coverage', () {
      for (final domain in domains) {
        test('All $domain entities should have test files', () {
          final entitiesPath = '$libPath/features/$domain/domain/entities';
          final testEntitiesPath = '$testPath/features/$domain/domain/entities';

          final entityFiles = _getDartFiles(entitiesPath);
          final missingTests = <String>[];

          for (final entityFile in entityFiles) {
            final fileName = _getFileName(entityFile);
            final testFileName =
                '${fileName.replaceAll('.dart', '')}_test.dart';
            final testFilePath = '$testEntitiesPath/$testFileName';

            if (!File(testFilePath).existsSync()) {
              missingTests.add(fileName);
            }
          }

          expect(
            missingTests,
            isEmpty,
            reason:
                'Missing test files for $domain entities:\n'
                '${missingTests.map((f) => '  - $f').join('\n')}\n'
                'Expected test files at: $testEntitiesPath/',
          );
        });
      }
    });

    group('DataSource Test Coverage', () {
      for (final domain in domains) {
        test('All $domain datasources should have test files', () {
          final datasourcesPath = '$libPath/features/$domain/data/datasources';
          final testDatasourcesPath =
              '$testPath/features/$domain/data/datasources';

          final datasourceFiles = _getDartFiles(datasourcesPath);
          final missingTests = <String>[];

          for (final datasourceFile in datasourceFiles) {
            final fileName = _getFileName(datasourceFile);
            final testFileName =
                '${fileName.replaceAll('.dart', '')}_test.dart';
            final testFilePath = '$testDatasourcesPath/$testFileName';

            if (!File(testFilePath).existsSync()) {
              missingTests.add(fileName);
            }
          }

          expect(
            missingTests,
            isEmpty,
            reason:
                'Missing test files for $domain datasources:\n'
                '${missingTests.map((f) => '  - $f').join('\n')}\n'
                'Expected test files at: $testDatasourcesPath/',
          );
        });
      }
    });

    group('Test Coverage Summary', () {
      test('Generate coverage report', () {
        final report = StringBuffer();
        report.writeln('=== Test Coverage Report ===\n');

        var totalSource = 0;
        var totalTests = 0;

        for (final domain in domains) {
          report.writeln('Domain: $domain');
          report.writeln('-' * 40);

          final usecases = _getDartFiles(
            '$libPath/features/$domain/domain/usecases',
          );
          final usecaseTests = _getDartFiles(
            '$testPath/features/$domain/domain/usecases',
          );

          final repositories = _getDartFiles(
            '$libPath/features/$domain/data/repositories',
          );
          final repositoryTests = _getDartFiles(
            '$testPath/features/$domain/data/repositories',
          );

          final entities = _getDartFiles(
            '$libPath/features/$domain/domain/entities',
          );
          final entityTests = _getDartFiles(
            '$testPath/features/$domain/domain/entities',
          );

          final datasources = _getDartFiles(
            '$libPath/features/$domain/data/datasources',
          );
          final datasourceTests = _getDartFiles(
            '$testPath/features/$domain/data/datasources',
          );

          report.writeln(
            '  UseCases:     ${usecases.length} source, ${usecaseTests.length} tests',
          );
          report.writeln(
            '  Repositories: ${repositories.length} source, ${repositoryTests.length} tests',
          );
          report.writeln(
            '  Entities:     ${entities.length} source, ${entityTests.length} tests',
          );
          report.writeln(
            '  DataSources:  ${datasources.length} source, ${datasourceTests.length} tests',
          );

          final domainSource =
              usecases.length +
              repositories.length +
              entities.length +
              datasources.length;
          final domainTests =
              usecaseTests.length +
              repositoryTests.length +
              entityTests.length +
              datasourceTests.length;

          totalSource += domainSource;
          totalTests += domainTests;

          final coverage = domainSource > 0
              ? (domainTests / domainSource * 100).toStringAsFixed(1)
              : '0.0';
          report.writeln('  Coverage: $coverage%');
          report.writeln('');
        }

        final totalCoverage = totalSource > 0
            ? (totalTests / totalSource * 100).toStringAsFixed(1)
            : '0.0';
        report.writeln('=== Total Coverage: $totalCoverage% ===');
        report.writeln('Source files: $totalSource, Test files: $totalTests');

        // ignore: avoid_print
        print(report.toString());

        expect(true, isTrue);
      });
    });

    group('Model Test Coverage', () {
      for (final domain in domains) {
        test('All $domain models should have test files', () {
          final modelsPath = '$libPath/features/$domain/data/models';
          final testModelsPath = '$testPath/features/$domain/data/models';

          final modelFiles = _getDartFiles(modelsPath);
          final missingTests = <String>[];

          for (final modelFile in modelFiles) {
            final fileName = _getFileName(modelFile);
            final testFileName =
                '${fileName.replaceAll('.dart', '')}_test.dart';
            final testFilePath = '$testModelsPath/$testFileName';

            if (!File(testFilePath).existsSync()) {
              missingTests.add(fileName);
            }
          }

          expect(
            missingTests,
            isEmpty,
            reason:
                'Missing test files for $domain models:\n'
                '${missingTests.map((f) => '  - $f').join('\n')}\n'
                'Expected test files at: $testModelsPath/',
          );
        });
      }
    });
  });
}

String _findProjectRoot() {
  var current = Directory.current;
  while (current.path != current.parent.path) {
    final pubspec = File('${current.path}/pubspec.yaml');
    if (pubspec.existsSync()) {
      return current.path;
    }
    current = current.parent;
  }
  return Directory.current.path;
}

List<String> _getDartFiles(String directoryPath) {
  final directory = Directory(directoryPath);
  if (!directory.existsSync()) {
    return [];
  }

  return directory
      .listSync()
      .where((entity) => entity is File && entity.path.endsWith('.dart'))
      .map((entity) => entity.path)
      .toList();
}

String _getFileName(String filePath) {
  return filePath.split('/').last;
}
