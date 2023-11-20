//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import file_selector_macos
<<<<<<< HEAD
import path_provider_foundation
import sqflite

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FileSelectorPlugin.register(with: registry.registrar(forPlugin: "FileSelectorPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
=======
import image_editor_common
import path_provider_foundation

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FileSelectorPlugin.register(with: registry.registrar(forPlugin: "FileSelectorPlugin"))
  ImageEditorPlugin.register(with: registry.registrar(forPlugin: "ImageEditorPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
>>>>>>> 69ce224 (Can just select image NO edit)
}
