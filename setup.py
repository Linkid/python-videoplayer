#!/usr/bin/env python

# from distutils.core import setup
# from distutils.extension import Extension
# from distutils.sysconfig import get_python_lib
#from distutils.command.clean import clean as Clean
# from setuptools import setup
from skbuild import setup  # This line replaces 'from setuptools import setup'
#from setuptools import Extension
import os
#import sys

#from Cython.Build import cythonize
# from Cython.Distutils import build_ext
#import pkgconfig


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


#def pc_info(pkg):
#    """
#    Obtain build options for a library from pkg-config and return a dict
#    that can be expanded into the argument list for Extension.
#    """
#
#    sys.stdout.write('checking for library %s... ' % pkg)
#
#    # pkg not found
#    if not pkgconfig.exists(pkg):
#        sys.stdout.write('not found')
#        sys.stderr.write('Could not find required library "%s".\n' % pkg)
#        sys.exit(1)
#
#    # get infos about the pkg
#    pkg_info = pkgconfig.parse(pkg)
#    info = {
#        'define_macros': pkg_info['define_macros'],
#        'include_dirs': pkg_info['include_dirs'],
#        'libraries': pkg_info['libraries'],
#        'library_dirs': pkg_info['library_dirs'],
#    }
#    sys.stdout.write('ok\n')
#    #sys.stdout.write('- cflags: %s\n' % cflags)
#    #sys.stdout.write('- libs: %s\n' % libs)
#
#    return info
#
#
#def combine_info(*args):
#    """ Combine multiple result dicts from L{pc_info} into one. """
#
#    # init
#    info = {
#        'define_macros': [],
#        'include_dirs': [],
#        'libraries': [],
#        'library_dirs': [],
#    }
#
#    # fill
#    for a in args:
#        info['define_macros'].extend(a.get('define_macros', []))
#        info['include_dirs'].extend(a.get('include_dirs', []))
#        info['libraries'].extend(a.get('libraries', []))
#        info['library_dirs'].extend(a.get('library_dirs', []))
#
#    return info


# Readme
readme_filepath = os.path.join(os.path.dirname(__file__), "README.md")
try:
    import pypandoc
    long_description = pypandoc.convert(readme_filepath, 'rst')
except ImportError:
    long_description = open(readme_filepath).read()


## find dependencies
#ogg_info = pc_info('ogg')
#glib_info = pc_info('glib-2.0')
#swscale_info = pc_info('libswscale')
#theoradec_info = pc_info('theoradec')
#if os.name == 'nt':
#    gl_info = {'libraries': ['opengl32']}
#    glib_info['define_macros'].append(('inline', '__inline'))
#else:
#    try:
#        gl_info = pc_info('gl')
#    except SystemExit:
#        os.environ['LDFLAGS'] = '-framework opengl'
#        os.environ['CFLAGS'] = '-framework opengl'
#        gl_info = {
#            'define_macros': [],
#            'include_dirs': [],
#            'libraries': [],
#            'library_dirs': [],
#        }
#
#
## sources
#ext_sources = [
#    'videoplayer/_VideoPlayer.pyx',
#    'videoplayer/VideoPlayer.c'
#]
#
## extension
#ext = Extension(
#    name='videoplayer.VideoPlayer',
#    sources=ext_sources,
#    **combine_info(
#        gl_info,
#        glib_info,
#        ogg_info,
#        swscale_info,
#        theoradec_info
#    )
#)

build_cmake_args = list()
if os.getenv("VCPKG_BUILD"):
    platform_windows = "x86" if os.getenv("PYTHON_ARCH") == "32" else "x64"
    build_cmake_args.append('-D_VCPKG=ON')
    #build_cmake_args.append('-DVCPKG_TARGET_TRIPLET:STRING={}-windows'.format(platform_windows))
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
