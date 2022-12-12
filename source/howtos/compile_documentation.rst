Compile the documentation
=========================

We adhere to the recommendations described on https://www.writethedocs.org/guide/ and https://documentation.divio.com/reference/. Reference guides are kept in a similar style as http://mavlink.io/en/services/mission.html.

.. code-block:: sh

   git clone git@github.com:BeagleSystems/docs.git
   cd docs
   vitualenv --python=python3 venv
   source venv/bin/activate
   # in venv
   pip install -r requirements.txt

   npm install @mermaid-js/mermaid-cli

Modify the CSS:

.. code-block:: sh

   cd ~/Development/beaglesystems
   git clone git@github.com:dayjaby/bootstrap
   cd bootstrap
   npm install
   npm install grunt
   ... modify files in ./less/ ...
   ./node_modules/.bin/grunt dist
   cp -r dist/* ~/Development/beaglesystems/sphinx-bootstrap-theme/bootstrap/static/bootstrap-3.4.1/

Create the documentation:

.. code-block:: sh

   sphinx-apidoc -f -o source/mqtt_bridge ../BeagleComrade/src/mqtt_bridge/src/mqtt_bridge
   make clean && make html

Instead of ˙make html˙ you can create the documentation via

.. code-block:: sh

   python3 -msphinx . _build

To generate a pdf using latex
"""""""""""""""""""""""""""""

.. code-block:: sh

   sudo apt install texlive-full
   sudo apt install texlive-latex-extra
   make latexpdf

The pdf file is located in doc/_build/latex/
