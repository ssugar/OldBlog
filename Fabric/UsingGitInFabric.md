## Using Git in Microsoft Fabric Notebooks

When working in Microsoft Fabric Notebooks, sometimes it can become necessary to clone a repository for use in the notebook.  One example of this necessity is when working with DBT packages for data transformation.

Inspiration for this article came from [here](https://community.fabric.microsoft.com/t5/General-Discussion/Assistance-Required-Git-Not-Installed-on-Runtime-1-2-for-Code/m-p/3532740#M2175%3Ftrk=article-ssr-frontend-pulse_little-text-block).  The instructions there have been cleaned up for easier consumption in this article.

## How to setup git in Microsoft Fabric Notebooks

### 1. Ensure your workspace is using Runtime 1.2

1. Go to your desired workspace
2. Click on "Workspace settings"
3. Click on "Data Engineering/Science
4. Click on "Spark compute"
5. In the "Runtime Version" dropdown, select "1.2 (Spark 3.4, Delta 2.4)"
6. Click "Save"

![UpdateRuntime](./updateRuntime.png)

### 2. Create a .yml file

1. Open up notepad, paste in the following and save it as a .yml file on your local machine

```yaml
name: Fabric1.2_GitWorkaround
channels:
  - conda-forge
  - defaults
dependencies:
  - git
```

### 3. Load the .yml file into your workspace

1. Go to your desired workspace (same one we confirmed is using Runtime 1.2)
2. Click on "Workspace settings"
3. Click on "Data Engineering/Science
4. Click on "Library management"
5. Click on "Add from .yml"
6. Select the .yml file created above
7. Click "Merge" in the pop up
8. Click "Apply" and "Apply" again

![Upload .yml](./uploadYml.png)

This change will then process in the background - it can take 20-30 minutes.

### 4. Confirm git is working in your notebook

1. Place the following code into a new notebook in the desired workspace

```python
%%bash
git --version
```

Output should look like this:

![gitVersion](./gitVersion.png)

## **Conclusion**

Having the ability to clone repositories into Fabric notebooks will further improve the usability of Fabric notebooks - especially when trying to work with DBT packages to enhance your data transformation capabilities.
