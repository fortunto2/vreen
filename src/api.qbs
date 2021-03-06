import qbs.base 1.0
import qbs.fileinfo 1.0 as FileInfo

Product {
    name: "vreen"

    property string headersDestination: "vreen"

    destination: vreen.core.libDestination
    type: ["dynamiclibrary", "installed_content"]

    //cpp.warningLevel: "all"
    cpp.includePaths: [
        "3rdparty",
        "api"
    ]
    cpp.defines: [
        "VK_LIBRARY",
        "K8JSON_INCLUDE_GENERATOR",
        "K8JSON_INCLUDE_COMPLEX_GENERATOR"
    ]
    cpp.visibility: "hidden"

    files: [
        "api/*.cpp",
    ]

    Properties {
        condition: qt.core.versionMajor === 5
        cpp.defines: outer.concat("QT_DISABLE_DEPRECATED_BEFORE=0")
    }

    Depends { name: "cpp" }
    Depends { name: "Qt"; submodules: ["core", "network", "gui"] }
    Depends { name: "k8json" }
    Depends { name: "vreen.core" }

//    Group {
//        qbs.installDir: "include/vreen/" + version + "/vreen/private"
//        fileTags: ["install"]
//        overrideTags: false
//        files: [
//            "api/*_p.h",
//            "api/draft/*_p.h",
//            "api/draft/*.h"
//        ]
//    }
//    Group {
//        qbs.installDir: "include/vreen"
//        fileTags: ["install"]
//        overrideTags: false
//        files: [
//            "api/*[^_][a-z].h",
//        ]
//    }

    ProductModule {
        Depends { name: "cpp" }
        Depends { name: "Qt"; submodules: ["core", "network", "gui"] }
        Depends { name: "vreen.core" }

        cpp.includePaths: [
            product.buildDirectory + "/GeneratedFiles/include",
            product.buildDirectory + "/GeneratedFiles/include/vreen",
            product.buildDirectory + "/GeneratedFiles/include/vreen/" +  vreen.core.version
        ]
        cpp.rpaths: product.buildDirectory + "/" + vreen.core.libDestination
    }

    Group {
        files: [
            "api/*_p.h",
            "api/draft/*_p.h",
            "api/draft/*.h"
        ]
        fileTags: ["devheader"]
        overrideTags: false
        qbs.installDir: "include/vreen/" + vreen.core.version + "/vreen/private"
    }

    Group {
        files: "api/*.h"
        excludeFiles: "api/*_p.h"
        fileTags: ["devheader"]
        overrideTags: false
        qbs.installDir: "include/vreen"
    }
}
