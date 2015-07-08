module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        clean: [
            "dist"
        ],
        coffee: {
            compile: {
                files: [
                    {
                        expand: true,
                        cwd: 'lib/',
                        src: ["**/*.coffee"],
                        dest: "dist/",
                        ext: ".js"
                    },
                    {src: "index.coffee", dest: "dist/index.js"}
                ]
            }
        },
        copy: {
            main: {
                files: [
                    {src: "package.json", dest: "dist/"},
                    {src: "README.md", dest: "dist/"}
                ]
            }
        },
        rename: {
            main: {
                files: [
                    {expand:true, flatten:true, src: "build/*.tgz", dest: "../dist/"}
                ]
            }
        },
        npm: {
            options: {
                cwd: "dist"
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