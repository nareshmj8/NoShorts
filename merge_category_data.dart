import 'dart:convert';
import 'dart:io';

void main() async {
  // Path to files
  final mainFilePath = 'assets/data/full_category_data.json';
  final newDataFiles = [
    'mini_moves_for_health.json',
    'win_any_argument.json',
    'home_physics_lab.json',
    'mind_meets_nature.json',
    'tech_ethics_101.json',
  ];

  try {
    // Read main file
    final mainFile = File(mainFilePath);
    if (!await mainFile.exists()) {
      print('Main file does not exist: $mainFilePath');
      return;
    }

    final mainFileContent = await mainFile.readAsString();
    final mainData = jsonDecode(mainFileContent) as Map<String, dynamic>;

    // Read and merge each new data file
    for (final newDataFilePath in newDataFiles) {
      final newDataFile = File(newDataFilePath);
      if (!await newDataFile.exists()) {
        print('New data file does not exist: $newDataFilePath');
        continue;
      }

      final newDataContent = await newDataFile.readAsString();
      final newData = jsonDecode(newDataContent) as Map<String, dynamic>;

      // Merge data
      mainData.addAll(newData);
      print('Merged data from: $newDataFilePath');
    }

    // Write back to main file
    final encoder = JsonEncoder.withIndent('  ');
    final mergedContent = encoder.convert(mainData);
    await mainFile.writeAsString(mergedContent);

    print('Successfully merged all data into: $mainFilePath');
  } catch (e) {
    print('Error: $e');
  }
}
