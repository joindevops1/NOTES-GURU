
directories=$(ls -dr */)

for i in ${directories}; do
  echo $i
  cd $i
  helm uninstall ${i::-1}
  cd ..
done
