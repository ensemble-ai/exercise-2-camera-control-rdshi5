# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Aaron Shan 
* *email:* shyshan@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [X] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera remains accurately centered on the vessel, indicated by the crosshairs at the screen's center, and smoothly tracks its movement even at hyperspeed.

___
### Stage 2 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [X] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The student's basic logic is fine, yet it deviates from the requirement that the camera should move horizontally left rather than to the bottom left. This incorrect camera movement causes an unintended effect: the vessel automatically shifts to the top-left corner, which is not desired. Additionally, when the player directs the vessel to the left boundary of the camera's square, the vessel shakes upon contact. This issue also occurs at all corners of the square except the top-left.

___
### Stage 3 ###

- [ ] Perfect
- [ ] Great
- [X] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The follow speed, catch up speed, and leash distance of the student’s implementation of the camera controller on Stage 3 corresponds to the instructions where the complexity is said to be suitable for RA and below. This behaviour provides a smooth tracking of the player at a slower than real time, and speeds up when the player ceases, ensuring that the camera never exceeds the set maximum distance from the player. Also enhanced, the controller overlays a five by five unit cross at the center of the screen during the operation of draw_camera_logic, thus creating good feedback. However, there is a noted issue with shaking of the vessel as much as it moves near the defined parameters of control logic of the camera.

___
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [X] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Stage 4 in the camera controller project can be noted that the student work satisfies most of the requirements offered in the instructions though there are some imperfections. The implementation accurately addresses the lead speed so that it is possible to approach the direction of input for the camera faster than the movement of the vessel. This nicely controls gameplay and adds an aspect of fluctuation in near real-time to a camera using catchup_delay_duration. This increases complexity due to waiting to make the catchup in point 2 until the target is stationary, according to the Project’s needs. They keep the maximum leash distance within the horizon range, and needed 5 by 5 unit cross is drawn when the draw_camera_logic is active. But there are some small imperfections, for example, shaking while the camera is in motion and the general fluidity of the process is not very high. 

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [X] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 

When analyzing the work done by the student on the Stage 5, the 4-way speedup push zone camera controller does not satisfy all the given criteria. First of all, the controller does not draw additional inner square of the speedup zone as it is suggested in the instructions. Even if one types “F” to load draw_camera_logic, the inner square is always missing, greatly resulting in a lack of real-time visual debug tools. The camera does function properly in the zone corresponding to the area between central zone and the outer push box; the camera who moves gradually towards the target and this was the design of the slow camera catch up. However, when the vessel touches the outer pushbox boundary either at the corners or along a line, the shaking is encountered. This raises questions about how different boundary interactions are managed, in terms of flow and stability of the camera motion.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####


#### Style Guide Exemplars ####

___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####

#### Best Practices Exemplars ####
