#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdbool.h>

#define NUM_CHILD 7
#define WITH_SIGNALS

int interrupt = 0;
pid_t children_pids[NUM_CHILD];

#ifdef WITH_SIGNALS
void trigger_interrupt() {
   printf("Keyboard interrupt triggered for parent[%d] .\n", getpid());
   interrupt = 1;
}

void interrupt_message() {
   printf(" Terminating child[%d] process with SIGTERM signal\n", getpid());
}
#endif

// Terminates all created children - sending SIGTERM signal.
void terminate(int fail_number) {
   for (int i = 0; i <= fail_number; i++) {
      printf("parent[%d]: sending SIGTERM signal to child[%d].\n", getpid(), children_pids[i]);
      kill(children_pids[i], SIGTERM);
   }
}

void child_process() {

   #ifdef WITH_SIGNALS
   signal(SIGINT, SIG_IGN); // Signal interrupt.
   signal(SIGTERM, interrupt_message); // Signal terminate.
   #endif

   printf("child[%d]: Created by parent[%d]\n", getpid(), getpid());
   sleep(10); // 10 sec delay.
   printf("child[%d]: Execution completed\n", getpid());
}

void create_child(int i) {

   pid_t pid = fork();

   if (pid == 0) {
      child_process();
      exit(0);
   } else if (pid == -1) {
      printf("child[pid]: Error. Can not create new child.");
      terminate(i);
      exit(1);
   } else {
      children_pids[i] = pid;
      printf("parent[%d]: Created child[%d]\n", getpid(), pid);
   }
}

int main() {

   // Force ignoring all signals and then restore the default handler for SIGCHLD signal.
   #ifdef WITH_SIGNALS
   for (int i = 0; i < _NSIG; i++) // NSIG is the total number of signals defined
      signal(i, SIG_IGN);

   signal(SIGCHLD, SIG_DFL); 
   signal(SIGINT, trigger_interrupt); 
   #endif

   for (int i = 0; i < NUM_CHILD; i++) {
      create_child(i);
      sleep(1); // 1sec delay.

      #ifdef WITH_SIGNALS
      if (interrupt != 0) {
         terminate(i);
         break; // End process of children creation.
      }
      #endif

   }

   pid_t pid;
   int status, code_zero_count = 0, code_one_count = 0;

   while (true) {
      pid = wait( & status); // wait() blocks the calling process until one of its child processes exits or a signal is received.

      if (pid == -1)
         break;

      if (WIFEXITED(status)) // WIFEXITED returns 1 if child terminated normally.
         printf("child[%d]: Exit status: %d\n", pid, WEXITSTATUS(status));

      if (WEXITSTATUS(status) == 1) // WEXITSTATUS returns the exit status of the child.
         code_one_count++;
      else if (WEXITSTATUS(status) == 0)
         code_zero_count++;

   }

   printf("\nparent[%d]: Children creation process has ended.\n", getpid());
   printf("Number of child processes: %d\n", NUM_CHILD);
   printf("Child processes exited with code 0: %d\n", code_zero_count);
   printf("Child processes exited with code 1: %d\n", code_one_count);

   // Setting all signals to default.
   #ifdef WITH_SIGNALS
   for (int i = 0; i < _NSIG; i++)
      signal(i, SIG_DFL);
   #endif

   return 0;

}
