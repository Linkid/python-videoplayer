#!/usr/bin/env python

#from distutils.command.clean import clean as Clean
from skbuild import setup
import subprocess
import os


#class CleanCommand(Clean):
#    """ Remove generated files """
#
#    def run(self):
#        Clean.run(self)
#
#        # remove build_ext inplace generated files
#        for dirpath, dirnames, filenames in os.walk('videoplayer'):
#            for filename in filenames:
#                extension = os.path.splitext(filename)[1]
#                # bin
#                if extension in (".so", ".dll", ".pyc"):
#                    print("Remove", filename)
#                    os.unlink(os.path.join(dirpath, filename))
#                    continue
#
#                # libs
#                if extension in ('.c', '.h'):
#                    pyx_file = str.replace(filename, extension, '.pyx')
#                    if os.path.exists(os.path.join(dirpath, pyx_file)):
#                        print("Remove", filename)
#                        os.unlink(os.path.join(dirpath, filename))


# Readme
readme_filepath = os.path.join(os.path.dirname(__file__), "README.md")
try:
    import pypandoc
    long_description = pypandoc.convert(readme_filepath, 'rst')
except ImportError:
    long_description = open(readme_filepath).read()

# Windows
if os.getenv("CI_WINDOWS"):
    print("****")
    print("VCINSTALLDIR: ", os.getenv("VCINSTALLDIR"))
    print("VS140COMNTOOLS", os.getenv("VS140COMNTOOLS"))
    print("****")
    arch = "x86" if os.getenv("PYTHON_ARCH") == "32" else "x86_amd64"
    call_args = ["cmd.exe", "/c", "call", "C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/vcvarsall.bat", arch]
    subprocess.check_call(call_args)

# Windows / vcpkg
build_cmake_args = list()
if os.getenv("VCPKG_BUILD"):
    platform_windows = "x86" if os.getenv("PYTHON_ARCH") == "32" else "x64"
    build_cmake_args.append('-D_VCPKG=ON')
    build_cmake_args.append('-DVCPKG_TARGET_TRIPLET:STRING={}-windows'.format(platform_windows))
    build_cmake_args.append('-DCMAKE_TOOLCHAIN_FILE={}'.format(os.getenv("VCPKG_TOOLCHAIN")))
    # C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/bin/x86_amd64/cl.exe
    # C:/Users/appveyor/AppData/Local/Programs/Common/Microsoft/Visual C++ for Python/9.0/VC/bin/cl.exe
    #build_cmake_args.append('-DCMAKE_C_COMPILER="cl.exe"')
    #build_cmake_args.append('-DCMAKE_C_COMPILER=clang-cl.exe')

    print("****")
    print(build_cmake_args)
    print(platform_windows)
    print("****")

# setup
setup(
    name='videoplayer',
    version='1.0',
    description='VideoPlayer is a C-extension in Python',
    long_description=long_description,
    long_description_content_type='text/markdown',
    author='FoFiX team',
    author_email='fofix@perdu.fr',
    license='GPLv2+',
    url='https://github.com/fofix/python-videoplayer',
    packages=['videoplayer'],
    package_data={'videoplayer': ['*.dll']},
    #include_package_data=True,
    zip_safe=False,
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU General Public License v2 or later (GPLv2+)',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Topic :: Multimedia',
        'Topic :: Software Development :: Libraries',
    ],
    keywords='ogg',
    #ext_modules=cythonize(ext, compiler_directives={'language_level': sys.version_info[0]}),
    #setup_requires=['cython', 'pytest-runner', 'cmake'],
    setup_requires=['pytest-runner', 'cmake'],
    #install_requires=[
    #    'Cython >= 0.27',
    #    'pkgconfig >= 1.5',
    #],
    test_suite="tests",
    tests_require=['pytest'],
    extras_require={
        'tests': ['pytest'],
    },
    #cmdclass={
    #    'clean': CleanCommand,
    #},
    # skbuild options
    cmake_with_sdist=True,
    cmake_args=build_cmake_args,
)
