module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        clean: [
            "build"
        ],
        coffee: {
            compile: {
                files: [
                    {
                        expand: true,
                        cwd: 'lib/',
                        src: ["**/*.coffee"],
                        dest: "build/lib/",
                        ext: ".js"
                    },
                    {src: "index.coffee", dest: "build/index.js"}
                ]
            }
        },
        copy: {
            main: {
                files: [
                    {src: "package.json", dest: "build/"},
                    {src: "README.md", dest: "build/"}
                ]
            }
        },
        rename: {
            main: {
                files: [
                    {expand:true, flatten:true, src: "build/*.tgz", dest: "dist/"}
                ]
            }
        },
        npm: {
            options: {
                cwd: "build"
            },
            package: "pack"
        }
    });
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-simple-npm');
    grunt.loadNpmTasks('grunt-rename');

    grunt.registerTask('default', ['clean', 'coffee:compile', 'copy', 'npm:package', 'rename', 'clean'])
};